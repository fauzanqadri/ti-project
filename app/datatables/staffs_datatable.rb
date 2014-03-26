class StaffsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		@view = view
	end
	
	def staffs
		@staffs ||= fetch_staffs
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: Staff.count,
			iTotalDisplayRecords: staffs.total_entries,
			aaData: data
		}
	end

	private

	def data
		staffs.map do |staff|
			[
				link_to(staff.full_name, staff, remote: true),
				staff.address.try(:truncate, 30),
				staff.born.to_formatted_s(:long_ordinal),
				staff.faculty.name,
				staff.staff_since.try(:to_formatted_s, :long_ordinal),
				act(staff)
			]
		end
	end

	def act staff
		action = []
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), staff, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), url_helpers.edit_staff_path(staff), :class => "btn btn-xs btn-primary", remote: true))
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_staffs
		staffs = Staff.includes(:faculty).order("#{sort_column} #{sort_direction}")
		staffs = staffs.page(page).per_page(per_page)
		if params[:sSearch].present?
			query = params[:sSearch]
			staffs = staffs.where{(full_name =~ "%#{query}%")}
		end
		staffs
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns = ["full_name", "", "born", "faculty_id", "staff_since", "created_at"]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

end