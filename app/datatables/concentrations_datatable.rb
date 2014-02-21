class ConcentrationsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		@view = view
	end
	
	def concentrations
		@concentrations ||= fetch_concentrations
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: Concentration.by_faculty(current_user.userable.faculty_id).size,
			iTotalDisplayRecords: concentrations.total_entries,
			aaData: data
		}
	end

	private

	def data
		concentrations.map do |concentration|
			[
				concentration.name,
				concentration.created_at.to_formatted_s(:long_ordinal),
				act(concentration)
			]
		end
	end

	def act concentration
		action = []
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), concentration, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), url_helpers.edit_concentration_path(concentration), :class => "btn btn-xs btn-primary", remote: true))
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_concentrations
		concentrations = Concentration.by_faculty(current_user.userable.faculty_id).order("#{sort_column} #{sort_direction}")
		concentrations = concentrations.page(page).per_page(per_page)
		if params[:sSearch].present?
			query = params[:sSearch]
			concentrations = concentrations.where{(name =~ "%#{query}%")}
		end
		concentrations
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns = %w[name created_at]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

end