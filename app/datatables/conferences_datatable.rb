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
			iTotalRecords: total_records.size,
			iTotalDisplayRecords: conferences.total_entries,
			aaData: data
		}
	end


	private

	def data
		if params[:datatable_format].present? && params[:datatable_format]  == 'true'
			return datatable_format
		else
			return default_format
		end
	end

	def datatable_format
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

	def default_format
		conferences.map do |conference|
			{
				skripsi: {
					title: conference.skripsi.title.try(:truncate, 120),
					student: { full_name: conference.skripsi.student.full_name },
					supervisors: supervisor(conference),
					url: url_helpers.skripsi_path(conference.skripsi),
					department: { name: conference.skripsi.student.department.name }
				},
				id: conference.id,
				tanggal: conference.tanggal,
				mulai: conference.mulai,
				selesai: conference.selesai,
				start: conference.start,
				end: conference.end,
				local: conference.local,
				type: conference.type,
				department_director_approval: conference.department_director_approval,
				examiners: examiners(conference),
				color: conference.color,
				manage_department_director_approval: can?(:manage_department_director_approval, conference),
				manage_conference_examiners: can?(:manage_conference_examiners, conference),
				manage_conference_scheduling: scheduling_conference(conference),
				set_local_conference: can?(:set_local_conference, conference)
			}	
		end
	end

	def status conference
		content_tag :div, :class => "text-center" do
			content_tag :button, content_tag(:i, "", :class => "fa fa-question-circle"), class: "popup btn btn-xs btn-info", "data-container" => "body", "data-toggle" => "popover", "data-placement" => "top", "data-content" => "#{conference.status}", "data-original-title" => "Status",type: "button"
		end
	end

	def supervisor conference
		conference.skripsi.supervisors.approved_supervisors.map{|supervisor| "<li>#{supervisor.lecturer.to_s}</li>" }.join("\n").html_safe
	end

	def examiners conference
		return nil if conference.type == "Seminar"
		conference.examiners.includes(:lecturer).map{|examiner| ["<li>#{examiner.lecturer.to_s} | #{link_to("<i class='fa fa-trash-o'></i>".html_safe, url_helpers.skripsi_sidang_examiner_path(conference.skripsi, conference, examiner), class: 'btn btn-xs btn-danger', method: :delete, data: {confirm: "Konfirmasi penghapusan ?"})}</li>"]}.join("\n").html_safe
	end

	def scheduling_conference conference
		if conference.type == "Sidang"
			return can?(:manage_sidang_scheduling, conference)
		else
			return can?(:manage_seminar_scheduling, conference)
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

	def total_records
		if params[:skripsi_id].present?
			conferences = skripsi.conferences.includes(:userable, skripsi: [{supervisors: :lecturer}, :student])
		end

		if current_user.userable_type == "Lecturer"
			conferences = Conference.includes(:userable, skripsi: [{supervisors: :lecturer}, :student]).by_department(department.id).approved_supervisors
		elsif current_user.userable_type == "Staff"
			f_id = faculty.id
			conferences = Conference.includes(:userable, skripsi: [{supervisors: :lecturer}, :student]).by_faculty(f_id).approved_supervisors.approved_department_director
		end

		if params[:use_pagination].present? && params[:use_pagination] == 'true'
			conferences = conferences.page(page).per_page(per_page)
		elsif params[:use_pagination].present? && params[:use_pagination] == 'false'
			conferences = conferences.page(1).per_page()
		end

		if params[:scheduled].present? && params[:scheduled] == 'true'
			conferences = conferences.scheduled
		elsif params[:scheduled].present? && params[:scheduled] == 'false'
			conferences = conferences.unscheduled
		end

		if params[:byType].present? && params[:byType] != 'all'
			q = params[:byType]
			conferences = conferences.where{(type == q)}
		end

		if params[:sSearch].present?
			query = params[:sSearch]
			conferences = conferences.joins{skripsi.student}.where{(skripsi.title =~ "%#{query}%") | (students.full_name =~ "%#{query}%") | (students.nim =~ "%#{query}%")}
		end
		conferences
	end

	def fetch_conferences
		conferences = total_records

		if params[:use_pagination].present? && params[:use_pagination] == 'true'
			conferences = conferences.page(page).per_page(per_page)
		else
			conferences = conferences.page(1).per_page(total_records.size)
		end

		conferences
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

end