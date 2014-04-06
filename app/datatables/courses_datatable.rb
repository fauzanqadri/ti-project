#it bit different from another class because it using different javascript framework
class CoursesDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 
	include SupervisorsHelper
	include MarkdownHelper

	def initialize view
		@view = view
	end

	def courses
		@courses ||= fetch_courses
	end

	def as_json opt = {}
		{
			cPage: page,
			cTotalRecords: totalRecords.size,
			cTotalDisplayRecords: courses.total_entries,
			cData: data
		}
	end

	def userable
		@userable ||= current_user.userable
	end

	private

	def totalRecords
		courses = send(userable.class.to_s.downcase)
		if params[:bySupervisor].present?
			query = params[:bySupervisor]
			courses = courses.by_supervisor(query)
		end
		if params[:cSearch].present?
			query = params[:cSearch]
			courses = courses.search(query)
		end
		if params[:byType].present? && !params[:byType].blank?
			query = params[:byType]
			courses = courses.where{(type.eq(query))}
		end
		courses
	end

	def student
		courses = Course.includes(:concentration, :student).by_department(userable.department_id)
		if params[:cByCurrentUser].present? && params[:cByCurrentUser] == 'true'
			courses = courses.by_student(userable.id)
		else
			s_id = userable.id
			courses = courses.where{( student_id != s_id)}
		end
		courses
	end

	def lecturer
		courses = Course.includes(:concentration, :student).by_department(userable.department_id)
		if params[:cByCurrentUser].present? && params[:cByCurrentUser] == 'true'
			courses = courses.by_lecturer(userable.id)
		else
			l_id = userable.id
			course_id = Supervisor.where{(lecturer_id == l_id) & (approved == true)}.pluck(:course_id)
			courses = courses.where{(id << course_id)}
		end
	end

	def staff
		raise StandardError.new("Not implement yet")
	end

	def data
		courses.map do |course|
			{
				title: course.title,
				description: render_markdown(course.description, truncate: 150),
				student: {
					full_name: course.student.full_name,
					photo: course.student.avatar.image.url(:medium)
				},
				concentration: {name: course.concentration.try(:name)},
				type: course.type,
				supervisors_count: course.supervisors_count,
				created_at: course.created_at.try(:to_formatted_s, :long_ordinal),
				action: action(course)
			}
		end
	end

	def action course
		edit_path = course.type == "Skripsi" ? url_helpers.edit_skripsi_path(course) : url_helpers.edit_pkl_path(course)
		become_supervisor_path = course.type == "Skripsi" ? url_helpers.become_supervisor_skripsi_supervisors_path(course) : url_helpers.become_supervisor_pkl_supervisors_path(course)
		act = []
		if can? :show, course
			act << raw(link_to content_tag(:i, "", :class => "fa fa-eye") + " Detail", course, class: "btn btn-default" )
		end
		if can_become_supervisor? course
			act << raw(link_to content_tag(:i, "", :class => "fa fa-gavel") + "Bimbing", become_supervisor_path, class: "btn btn-success",method: :post, data: {confirm: "Konfirmasi Pembimbing ?"})
		end
		if can? :edit, course
			act << raw(link_to content_tag(:i, "", :class => "fa fa-edit") + " Edit", edit_path, class: "btn btn-primary", remote: true )
		end
		if can? :destroy, course
			act << raw(link_to content_tag(:i, "", :class => "fa fa-trash-o") + " Hapus", course, class: "btn btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"} )
		end
		content_tag :div, :class => "text-center" do
			raw(act.join(" "))
		end

	end

	def fetch_courses
		courses = totalRecords.page(page).per_page(per_page)
		courses
	end

	def page
		params[:cDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:cDisplayLength].to_i > 0 ? params[:cDisplayLength].to_i : 10
	end
end