class ImportsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		@view = view
	end
	
	def imports
		@imports ||= fetch_imports
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: total_records.size,
			iTotalDisplayRecords: imports.total_entries,
			aaData: data
		}
	end

	private

	def data
		imports.map do |import|
			[
				import.package_file_name,
				import.package_original_file_name,
				import.klass_action,
				import.total_row,
				import.department.name,
				import.userable.to_s,
				import.userable_type,
				import.status,
				act(import)
			]
		end
	end

	def act import
		action = []
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-download"), url_helpers.download_import_path(import), :class => "btn btn-xs btn-primary", method: :post))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-arrow-up"), url_helpers.populate_import_path(import), :class => "btn btn-xs btn-success", method: :post))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), import, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def total_records
		imports = if current_user.userable_type == "Lecturer"
			Import.includes(:department, :userable).by_department(current_user.userable.department_id)
		else
			Import.includes(:department, :userable).by_faculty(current_user.userable.faculty_id)
		end
		imports.order("#{sort_column} #{sort_direction}")
	end

	def fetch_imports
		imports = total_records
		imports = imports.page(page).per_page(per_page)
		imports
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns = ["package_file_name", "", "klass_action", "total_row", "department_id", "", "userable_type", "status"]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end
end
