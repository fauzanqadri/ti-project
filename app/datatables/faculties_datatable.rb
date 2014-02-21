class FacultiesDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		@view = view
	end
	
	def faculties
		@faculties ||= fetch_faculties
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: Faculty.count,
			iTotalDisplayRecords: faculties.total_entries,
			aaData: data
		}
	end

	private

	def data
		faculties.map do |faculty|
			[
				faculty.name,
				faculty.website,
				faculty.created_at.to_formatted_s(:long_ordinal),
				act(faculty)
			]
		end
	end

	def act faculty
		action = []
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), faculty, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), url_helpers.edit_faculty_path(faculty), :class => "btn btn-xs btn-primary", remote: true))
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_faculties

		faculties = Faculty.order("#{sort_column} #{sort_direction}")
		faculties = faculties.page(page).per_page(per_page)
		if params[:sSearch].present?
			query = params[:sSearch]
			faculties = faculties.where{(name =~ "%#{query}%")}
		end
		faculties
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