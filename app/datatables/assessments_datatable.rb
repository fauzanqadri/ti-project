class AssessmentsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		@view = view
	end

	def department
		@department ||= current_user.userable.department
	end
	
	def assessments
		@assessments ||= fetch_assessments
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: total_records,
			iTotalDisplayRecords: assessments.total_entries,
			aaData: data
		}
	end

	private

	def data
		assessments.map do |assessment|
			[
				assessment.aspect,
				assessment.percentage,
				assessment.category,
				act(assessment)
			]
		end
	end

	def act assessment
		action = []
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), assessment, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), url_helpers.edit_assessment_path(assessment), :class => "btn btn-xs btn-primary", remote: true))
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def total_records
		department.assessments.size
	end

	def fetch_assessments
		assessments = department.assessments.order("#{sort_column} #{sort_direction}")
		assessments = assessments.page(page).per_page(per_page)
		if params[:sSearch].present?
			query = params[:sSearch]
			assessments = assessments.where{(aspect =~ "%#{query}%") | (category =~ "%#{query}%")}
		end
		assessments
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns = ["aspect", "percentage", "category"]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

end