class PklAssessmentsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes'

	def initialize view
		@view = view
	end


	def department
		@department ||= current_user.userable.department
	end

	def pkl_assessments
		@pkl_assessments ||= fetch_pkl_assessments
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: total_records.size,
			iTotalDisplayRecords: pkl_assessments.total_entries,
			aaData: data
		}
	end

	private
	def data
		pkl_assessments.map do |pkl_assessment|
			[
				pkl_assessment.aspect,
				pkl_assessment.category,
				pkl_assessment.percentage,
				act(pkl_assessment)
			]
		end
	end

	def act pkl_assessment
		action = []
		if can? :edit, pkl_assessment
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), url_helpers.edit_pkl_assessment_path(pkl_assessment), :class => "btn btn-xs btn-primary", remote: true))
		end

		if can? :destroy, pkl_assessment
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), pkl_assessment, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		end
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def total_records
		pkl_assessments = department.pkl_assessments.order("#{sort_column} #{sort_direction}")
		if params[:sSearch].present?
			query = params[:sSearch]
			pkl_assessments = pkl_assessments.where{(aspect =~ "%#{query}%") | (category =~ "%#{query}%")}
		end
		pkl_assessments
	end

	def fetch_pkl_assessments
		total_records.page(page).per_page(per_page)
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