class DepartmentsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		@view = view
	end
	
	def departments
		@departments ||= fetch_departments
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: current_user.userable.faculty.departments.size,
			iTotalDisplayRecords: departments.total_entries,
			aaData: data
		}
	end

	private

	def data
		departments.map do |department|
			[
				department.name,
				department.website,
				department.created_at.to_formatted_s(:long_ordinal),
				act(department)
			]
		end
	end

	def act department
		action = []
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), department, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), url_helpers.edit_department_path(department), :class => "btn btn-xs btn-primary", remote: true))
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_departments
		departments = current_user.userable.faculty.departments.order("#{sort_column} #{sort_direction}")
		departments = departments.page(page).per_page(per_page)
		if params[:sSearch].present?
			query = params[:sSearch]
			departments = departments.where{(name =~ "%#{query}%")}
		end
		departments
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns = %w[name website created_at]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

end