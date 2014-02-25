class SkripsiConferencesDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize view
		@view = view
	end

	def conferences
		@conferences ||= fetch_conferences
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: conferences.size,
			# iTotalDisplayRecords: students.total_entries,
			aaData: data
		}
	end

	def skripsi
		@skripsi ||=  Skripsi.find(params[:skripsi_id])
	end

	private

	def data
		conferences.map do |conference|
			[
				conference.start.try(:strftime, "%d-%m-%Y %I:%M"),
				conference.end.try(:strftime, "%d-%m-%Y %I:%M"),
				conference.local,
				conference.type,
				conference.userable.to_s,
				status(conference),
				act(conference)
			]
		end
	end

	def act conference
		action = []
		conference_path = conference.type == "Sidang" ? url_helpers.skripsi_sidang_path(skripsi, conference) : url_helpers.skripsi_seminar_path(skripsi, conference)
		# action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), student, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-print"), conference_path, :class => "btn btn-xs btn-primary", remote: true))
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def status conference
		content_tag :div, :class => "text-center" do
			content_tag :button, content_tag(:i, "", :class => "fa fa-question-circle"), class: "popup btn btn-xs btn-info", "data-container" => "body", "data-toggle" => "popover", "data-placement" => "top", "data-content" => "#{conference.status}", "data-original-title" => "Status",type: "button"
			# raw(link_to(content_tag(:i, "", :class => "fa fa-question"), "#", :class => "btn btn-xs btn-info", "data-container" => "body", "data-toggle" => "popover", "data-placement" => "top", "data-content" => "#{conference.status}"))
		end
	end

	def fetch_conferences
		# if params[:skripsi_id].present?
			
		# else

		# end
		
		conferences = skripsi.conferences.includes(:userable).order("created_at asc")
		# conferences = conferences.page(page).per_page(per_page)
		conferences
		# id = current_user.userable.faculty_id
		# students = Student.includes(:department).by_faculty(id).order("#{sort_column} #{sort_direction}")
		# students = students.page(page).per_page(per_page)
		# if params[:sSearch].present?
		# 	query = params[:sSearch]
		# 	students = students.where{(full_name =~ "%#{query}%") | (nim =~ "%#{query}%")}
		# end
		# students
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns =["start", "full_name", "born", "","created_at"]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

end