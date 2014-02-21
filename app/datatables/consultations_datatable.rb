class ConsultationsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes'

	def initialize(view)
		@view = view
	end
	
	def consultations
		@consultations ||= fetch_consultations
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: Course.find(course_id).consultations.size,
			iTotalDisplayRecords: consultations.total_entries,
			aaData: data
		}
	end

	private

	def data
		consultations.map do |consultation|
			[
				consultation.created_at.try(:to_formatted_s, :long_ordinal),
				consultation.consultable.lecturer.to_s,
				consultation.consultable_type,
				consultation.next_consult.try(:to_formatted_s, :long_ordinal),
				consultation.content,
				act(consultation)
			]
		end
	end

	def act consultation
		course = consultation.course
		consultation_path = course.type == "Skripsi" ? url_helpers.skripsi_consultation_path(course, consultation) : url_helpers.pkl_consultation_path(course, consultation)
		edit_consultation_path = course.type == "Skripsi" ? url_helpers.edit_skripsi_consultation_path(course, consultation) : url_helpers.edit_pkl_consultation_path(course, consultation)
		action = []
		if can? :update, consultation
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), edit_consultation_path, :class => "btn btn-xs btn-primary", remote: true))
		end

		if can? :destroy, consultation
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-times"), consultation_path, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		end
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def fetch_consultations
		course = Course.find(course_id)
		consultations = course.consultations.includes(consultable: :lecturer).includes(:course, :consultable).order("#{sort_column} #{sort_direction}")
		consultations = consultations.page(page).per_page(per_page)
		if params[:sSearch].present?
			query = params[:sSearch]
			consultations = consultations.where{(content =~ "%#{query}%")}
		end
		consultations
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns = ["created_at", "", "", "next_consult", ""]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

	def course_id
		return params[:skripsi_id] if params[:skripsi_id].present?
		return params[:pkl_id]
	end
end