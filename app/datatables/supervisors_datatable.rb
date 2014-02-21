class SupervisorsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :can?, to: :@view
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
			# iTotalRecords: Course.find(course_id).papers.size,
			# iTotalDisplayRecords: papers.total_entries,
			aaData: data
		}
	end

	private

	def data
		supervisors.map do |supervisor|
			[
				supervisor.lecturer.to_s,
				act(supervisor)
			]
		end
	end

	def act supervisor
		course = supervisor.course
		supervisor_path = course.type == "Skripsi" ? url_helpers.skripsi_supervisor_path(course, supervisor) : url_helpers.pkl_supervisor_path(course, supervisor)
		approve_path = course.type == "Skripsi" ? url_helpers.approve_skripsi_supervisor_path(course, supervisor) : url_helpers.approve_pkl_supervisor_path(course, supervisor)
		action = []

		if can? :approve, supervisor
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-check"), approve_path, :class => "btn btn-xs btn-success", data: {confirm: "Konfirmasi Persetujuan ?"}))
		end

		if can? :destroy, supervisor
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), supervisor_path, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		end
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_supervisors
		course = Course.find(course_id)
		supervisors = course.supervisors.includes(:course, :lecturer).joins{lecturer}.order("lecturers.full_name #{sort_direction}")
		if params[:pending_request].present? && params[:pending_request] == 'true'
			supervisors = supervisors.where{(approved == false)}
		else
			supervisors = supervisors.where{(approved == true)}
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
		columns = %w[name]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

	def course_id
		course_id = params[:skripsi_id].present? ? params[:skripsi_id] : params[:pkl_id]
		course_id
	end
end