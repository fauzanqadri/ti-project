class WaitingApprovalDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		@view = view
	end
	
	def supervisors
		@supervisors ||= fetch_supervisors
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: current_user.userable.supervisors.where{(approved == false)}.size,
			iTotalDisplayRecords: supervisors.total_entries,
			aaData: data
		}
	end

	private

	def data
		supervisors.map do |supervisor|
			[
				supervisor.course.title,
				supervisor.course.student.to_s,
				supervisor.course.type,
				supervisor.created_at.to_formatted_s(:long_ordinal),
				act(supervisor)
			]
		end
	end

	def act supervisor
		course = supervisor.course
		supervisor_path = course.type == "Skripsi" ? url_helpers.skripsi_supervisor_path(course, supervisor) : url_helpers.pkl_supervisor_path(course, supervisor)
		approve_path = course.type == "Skripsi" ? url_helpers.approve_skripsi_supervisor_path(course, supervisor) : url_helpers.approve_pkl_supervisor_path(course, supervisor)
		action = []
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-check"), approve_path, :class => "btn btn-xs btn-success", method: :post, data: {confirm: "Konfirmasi Persetujuan ?"}))
		action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), supervisor_path, method: :delete, :class => "btn btn-xs btn-danger", data: {confirm: "Konfirmasi Penolakan ? "}))
		action << raw(link_to content_tag(:i, "", :class => "fa fa-eye"), course, class: "btn btn-default btn-xs" )
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_supervisors
		supervisors = current_user.userable.supervisors.joins{course.student}.where{(approved == false)}.order("#{sort_column} #{sort_direction}")
		supervisors = supervisors.page(page).per_page(per_page)
		if params[:sSearch].present?
			query = params[:sSearch]
			supervisors = supervisors.where{students.full_name =~ "%#{query}%"}
		end
		supervisors
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns = ["", "", "courses.type", "created_at", ""]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

end