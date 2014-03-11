class PublishedCoursesDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize view
		@view = view
	end

	def courses
		@courses ||= fetch_courses
	end

	def as_json options = {}
		{
			sEcho: page,
			iTotalRecords: total_records.size,
			iTotalDisplayRecords: courses.total_entries,
			aaData: data
		}
	end

	private
	def data
		courses.map do |course|
			{
				title: course.title,
				description: course.description.try(:truncate, 300),
				student: {
					full_name: course.student.full_name,
					department: {
						name: course.student.department.name,
						faculty: {
							name: course.student.department.faculty.name
						}
					}
				},
				concentration: {name: course.concentration.try(:name)},
				type: course.type,
				created_at: course.created_at.try(:to_formatted_s, :long_ordinal),
				action: act(course)
			}
		end
	end

	def act course
		# course_url = course.type == "Skripsi" ? url_helpers.skripsi_path(course) : url_helpers.pkl_path(course)
		acted = []
		acted << raw(link_to content_tag(:i, "", :class => "fa fa-eye") + " Detail", course, class: "btn btn-primary" )
		content_tag :div, :class => "text-center" do
			raw(acted.join(" "))
		end
	end

	def total_records
		courses = Course.includes(:concentration, student: {department: :faculty}).is_finish
		if params[:byType].present? && params[:byType] != "all"
			query = params[:byType]
			courses = courses.by_type(query)
		end
		if params[:faculty_id].present?
			f_id = params[:faculty_id]
			courses = courses.by_faculty(f_id)
		end
		if params[:department_id].present?
			d_id = params[:department_id]
			courses = courses.by_department(d_id)
		end
		if params[:concentration_id].present?
			c_id = params[:concentration_id]
			courses = courses.by_concentration(c_id)
		end
		if params[:sSearch].present?
			query = params[:sSearch]
			courses = courses.published_search(query)
		end
		courses
	end

	def fetch_courses
		courses = total_records.page(page).per_page(per_page)
		courses
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

end