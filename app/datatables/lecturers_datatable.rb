class LecturersDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		@view = view
	end
	
	def lecturers
		@lecturers ||= fetch_lecturers
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: Lecturer.by_faculty(current_user.userable.faculty_id).size,
			iTotalDisplayRecords: lecturers.total_entries,
			aaData: data
		}
	end

	private

	def data
		lecturers.map do |lecturer|
			[
				lecturer.nip,
				lecturer.nid,
				link_to(lecturer.to_s, lecturer, remote: true),
				lecturer.department.name,
				lecturer.created_at.try(:to_formatted_s, :long_ordinal),
				act(lecturer)
			]
		end
	end

	def act lecturer
		action = []
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), lecturer, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), url_helpers.edit_lecturer_path(lecturer), :class => "btn btn-xs btn-primary", remote: true))
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_lecturers
		id = current_user.userable.faculty_id
		lecturers = Lecturer.includes(:department).by_faculty(current_user.userable.faculty_id).order("#{sort_column} #{sort_direction}")
		lecturers = lecturers.page(page).per_page(per_page)
		if params[:sSearch].present?
			query = params[:sSearch]
			lecturers = lecturers.where{(full_name =~ "%#{query}%") | (nip =~ "%#{query}%") | (nid =~ "%#{query}%")}
		end
		lecturers
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns =["nip", "nid", "full_name","", "created_at"]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

end