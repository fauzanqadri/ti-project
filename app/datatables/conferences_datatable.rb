class ConferencesDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes'

	def initialize view
		@view = view
	end

	def conferences
		@conferences ||= fetch_conferences
	end

	def userable
		@userable ||= current_user.userable
	end

	def department
		@department ||= userable.department
	end

	def faculty
		if current_user.userable_type == "Staff"
			@faculty ||= userable.faculty
		else
			@faculty ||= department.faculty
		end
	end

	def skripsi
		if current_user.userable_type == "Student"
			@skripsi ||= userable.skripsis.find(params[:skripsi_id])
		elsif current_user.userable_type == "Lecturer"
			@skripsi ||= Skripsi.by_department(department.id).find(params[:skripsi_id])
		else
			@skripsi ||= Skripsi.by_faculty(faculty.id).find(params[:skripsi_id])
		end
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: conferences.size,
			iTotalDisplayRecords: conferences.size,
			aaData: data
		}
	end


	private

	def data
		conferences.map do |conference|
			[
				conference.tanggal,
				conference.mulai,
				conference.selesai,
				conference.local,
				conference.type,
				conference.userable.to_s,
				status(conference),
				act(conference)
			]
		end
	end


	def status conference
		content_tag :div, :class => "text-center" do
			content_tag :button, content_tag(:i, "", :class => "fa fa-question-circle"), class: "popup btn btn-xs btn-info", "data-container" => "body", "data-toggle" => "popover", "data-placement" => "top", "data-content" => "#{conference.status}", "data-original-title" => "Status",type: "button"
		end
	end

	def act conference
		action = []
		conference_path = conference.type == "Sidang" ? url_helpers.skripsi_sidang_path(skripsi, conference) : url_helpers.skripsi_seminar_path(skripsi, conference)
		if can? :show, conference
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-print"), conference_path, :class => "btn btn-xs btn-primary", remote: true))
		end
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_conferences
		conferences = skripsi.conferences.includes(:userable, :skripsi)
		conferences
	end

end