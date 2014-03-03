class ConferenceLogsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize view
		@view = view
	end

	def conference_logs
		@conference_logs ||= fetch_conference_logs
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: current_user.userable.conference_logs.size,
			iTotalDisplayRecords: conference_logs.total_entries,
			aaData: data
		}
	end

	private

	def data
		conference_logs.map do |conference_log|
			[
				conference_log.conference.skripsi.title.try(:truncate, 100).upcase,
				conference_log.conference.skripsi.student.to_s,
				conference_log.conference.tanggal,
				conference_log.conference.mulai,
				conference_log.conference.selesai,
				conference_log.conference.local,
				conference_log.conference.type,
				conference_log.status,
				act(conference_log)
			]
		end
	end

	# def seminar_undertake_plan conference_log
	# 	return conference_log.conference.undertake_plan.try(:to_formatted_s, :long_ordinal) if conference_log.conference.type == "Seminar"
	# 	return "-"
	# end

	def fetch_conference_logs
		if current_user.userable_type == "Lecturer"
			conference_logs = current_user.userable.conference_logs.order("approved #{sort_direction}")
			conference_logs = conference_logs.page(page).per_page(per_page)
			if params[:sSearch].present?
				q = params[:sSearch]
				conference_logs = conference_logs.joins{conference.skripsi.student}.where{(students.full_name =~ "%#{q}%") | (courses.title =~ "%#{q}%")}
			end
			conference_logs
		end
	end

	def act conference_log
		action = []
		if !conference_log.approved
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-check"), url_helpers.approve_conference_log_path(conference_log), :class => "btn btn-xs btn-success", method: :put, data: {confirm: "Konfirmasi Persetujuan ?"}))
		end
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-eye"), conference_log.conference.skripsi, :class => "btn btn-xs btn-primary"))

		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	# def sort_column
	# 	columns = %w[name]
	# 	columns[params[:iSortCol_0].to_i]
	# end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

	def course_id
		course_id = params[:skripsi_id].present? ? params[:skripsi_id] : params[:pkl_id]
		course_id
	end
end