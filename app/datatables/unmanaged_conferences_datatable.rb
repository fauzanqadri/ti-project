class UnmanagedConferencesDatatable
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

	def as_json opt = {}
		{
			sEcho: page,
			iTotalRecords: total_records.size,
			iTotalDisplayRecords: conferences.total_entries,
			aaData: data
		}
	end


	private

	def data
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
				set_local_conference: set_local_conference(conference)
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
		exms = []
		conference.examiners.includes(:lecturer).each do |examiner|
			lecturer_name = "#{examiner.lecturer.to_s}"
			delete_link = if can? :manage, Examiner
				" | #{link_to("<i class='fa fa-trash-o'></i> Hapus".html_safe, url_helpers.skripsi_sidang_examiner_path(conference.skripsi, conference, examiner), method: :delete, data: {confirm: "Konfirmasi penghapusan ?"})}".html_safe
			else
				""
			end
			exms << "<li>#{lecturer_name}#{delete_link}</li>".html_safe
		end
		exms.join("\n")
	end

	def scheduling_conference conference
		if conference.type == "Sidang"
			return can?(:manage_sidang_scheduling, conference)
		else
			return can?(:manage_seminar_scheduling, conference)
		end
	end

	def set_local_conference conference
		if conference.type == "Sidang"
			return can?(:set_local_sidang, conference)
		else
			return can?(:set_local_seminar, conference)
		end
	end

	def destroy_examiner conference, examiner
		return false if conference.type == "Seminar"
		can?(:destroy, examiner)
	end

	def total_records
		if current_user.userable_type == "Lecturer"
			conferences = Conference.includes(skripsi: [{supervisors: :lecturer}, :student]).by_department(department.id).approved_supervisors
		elsif current_user.userable_type == "Staff"
			f_id = faculty.id
			conferences = Conference.includes(skripsi: [{supervisors: :lecturer}, :student]).by_faculty(f_id).approved_supervisors.approved_department_director
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