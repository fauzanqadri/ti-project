class StudentsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		@view = view
	end
	
	def students
		@students ||= fetch_students
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: total_records.size,
			iTotalDisplayRecords: students.total_entries,
			aaData: data
		}
	end

	private

	def data
		students.map do |student|
			[
				student.nim,
				link_to(student.full_name, student, remote: :true),
				student.born.try(:to_formatted_s, :long_ordinal),
				student.student_since,
				student.skripsis_count,
				student.pkls_count,
				student.department.name,
				student.created_at.try(:to_formatted_s, :long_ordinal),
				act(student)
			]
		end
	end

	def act student
		action = []
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), student, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), url_helpers.edit_student_path(student), :class => "btn btn-xs btn-primary", remote: true))
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def total_records
		students = if current_user.userable.respond_to? :faculty_id
			Student.includes(:department).by_faculty(current_user.userable.faculty_id)
		else
			Student.includes(:department).by_department(current_user.userable.department_id)
		end.order("#{sort_column} #{sort_direction}")
		if params[:sSearch].present?
			query = params[:sSearch]
			students = students.search(query)
		end
		students
	end

	def fetch_students
		students = total_records.page(page).per_page(per_page)
		students
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns =["nim", "full_name", "born", "student_since", "", "", "department_id", "created_at"]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

end