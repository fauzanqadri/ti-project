class PapersDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		@view = view
	end
	
	def papers
		@papers ||= fetch_papers
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: Course.find(course_id).papers.size,
			# iTotalDisplayRecords: papers.total_entries,
			aaData: data
		}
	end

	private

	def data
		papers.map do |paper|
			[
				paper.name,
				act(paper)
			]
		end
	end

	def act paper
		course = paper.course
		paper_path = course.type == "Skripsi" ? url_helpers.skripsi_paper_path(course, paper) : url_helpers.pkl_paper_path(course, paper)
		action = []
		if can? :read, paper
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-eye"), paper_path, :class => "btn btn-xs btn-primary", remote: :true))
		end

		if can? :destroy, paper
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), paper_path, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		end

		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_papers
		course = Course.find(course_id)
		papers = course.papers.includes(:course).order("#{sort_column} #{sort_direction}")
		# papers = papers.page(page).per_page(per_page)
		papers
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns = %w[name]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

	def course_id
		course_id = params[:skripsi_id].present? ? params[:skripsi_id] : params[:pkl_id]
		course_id
	end

end