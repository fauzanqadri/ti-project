class ReportsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize view
		@view = view
	end

	def reports
		@reports ||= fetch_reports
	end

	def course
		@course ||= Course.find(course_id)
	end

	def as_json options = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: reports.size,
			aaData: data
		}
	end


	private

	def data
		reports.map do |report|
			[
				report.name,
				report.created_at.to_formatted_s(:long_ordinal),
				act(report)
			]
		end
	end

	def act report
		report_path = course.class == Skripsi ? url_helpers.skripsi_report_path(course, report) : url_helpers.pkl_report_path(course, report)
		action = []
		if can? :show, report
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-eye"), report_path, :class => "btn btn-xs btn-primary", remote: :true))
		end
		if can? :destroy, report
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), report_path, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		end
		
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_reports
		 course.reports
	end

	def course_id
		course_id = params[:skripsi_id].present? ? params[:skripsi_id] : params[:pkl_id]
		course_id
	end



end