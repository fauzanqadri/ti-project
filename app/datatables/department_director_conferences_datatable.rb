class DepartmentDirectorConferencesDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, :concat, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 
	def initialize view
		@view = view
	end

	def conferences
		@conferences ||= fetch_conferences
	end

	def as_json option = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: total_records,
			iTotalDisplayRecords: conferences.size,
			aaData: data
		}
	end

	private

	def data
		if current_user.userable_type == "Lecturer" && current_user.userable.is_admin?
			data = conferences.map do |conference|
				[
					conference.skripsi.title.try(:truncate, 100),
					conference.skripsi.student.full_name,
					skripsi_supervisors(conference),
					conference.type,
					sidang_examiners(conference),
					conference_undertake_plan(conference),
					implementation(conference),
					act(conference)
				]
			end
		end
		data
	end

	def conference_undertake_plan conference
		return conference.undertake_plan.try(:to_formatted_s, :long_ordinal) if conference.type == "Seminar"
		return "-"
	end

	def implementation conference
		content_tag :dl do
			concat(content_tag :dt, "Mulai")
			concat(content_tag :dd, "#{conference.start.try(:to_formatted_s, :long_ordinal)}" )
			concat(content_tag :dt, "Selesai")
			concat(content_tag :dd, "#{conference.end.try(:to_formatted_s, :long_ordinal)}" )
			concat(content_tag :dt, "Lokal")
			concat(content_tag :dd, "#{conference.local}" )
			
		end
	end

	def act conference
		action = []
		skripsi = conference.skripsi
		conference_approve_path = conference.type == "Sidang" ? url_helpers.edit_department_director_approval_skripsi_sidang_path(skripsi, conference) : url_helpers.edit_department_director_approval_skripsi_seminar_path(skripsi, conference)
		if can? :show, conference.skripsi
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-book"), skripsi, :class => "btn btn-xs btn-default"))
		end

		if can? :update_department_director_approval, conference
			if conference.department_director? && conference.undertake_plan.present?
				action << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), conference_approve_path, :class => "btn btn-xs btn-success", remote: true))
			else
				action << raw(link_to(content_tag(:i, "", :class => "fa fa-check"), conference_approve_path, :class => "btn btn-xs btn-primary", remote: true))
			end
		end

		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end

	end

	def total_records
		conferences = Conference.by_department(current_user.userable.department_id).approved_supervisors
		conferences.size
	end

	def fetch_conferences
		conferences = Conference.includes(skripsi: {supervisors: :lecturer}).by_department(current_user.userable.department_id).approved_supervisors
		conferences = conferences.page(page).per_page(per_page)
		if params[:sSearch].present?
			q = params[:sSearch]
			conferences = conferences.where{(students.full_name =~ "%#{q}%")}
		end
		conferences
	end

	def skripsi_supervisors conference
		content_tag :ol do
			raw(
				conference.skripsi.supervisors.approved_supervisors.collect do |supervisor|
					content_tag :li, "#{supervisor.lecturer.to_s}"
				end.join("")
			)
		end
	end

	def sidang_examiners conference
		return "-" if conference.type == "Seminar"
		content_tag :ol do
			raw(
				conference.examiners.collect do |examiner|
					content_tag :li, "#{examiner.lecturer.try(:to_s)}"
				end.join("")
			)
		end
		
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

end