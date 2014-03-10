class SurceasesDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes'

	def initialize view
		@view = view
	end

	def surceases
		@surceases ||= fetch_surceases
	end

	def as_json options = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: total_records.size,
			iTotalDisplayRecords: surceases.total_entries,
			aaData: data
		}
	end


	private

	def data
		surceases.map do |surcease|
			[
				surcease.course.title.try(:truncate, 120),
				surcease.course.student.to_s,
				surcease.course.type,
				course_supervisors(surcease.course),
				surcease.provenable_type,
				approve_disaprove_action(surcease),
				action(surcease.course)
			]
		end
	end

	def approve_disaprove_action surcease
		act = []
		if surcease.is_finish?
			act << raw(link_to(content_tag(:i, "", class: "fa fa-times"), url_helpers.disapprove_surcease_path(surcease), class: "btn btn-danger btn-xs", remote: :true, method: :post, data: {confirm: "Confirmasi pembatalan persetujuan ?"}))
		else
			act << raw(link_to(content_tag(:i, "", class: "fa fa-check"), url_helpers.approve_surcease_path(surcease), class: "btn btn-success btn-xs", remote: :true, method: :post, data: {confirm: "Confirmasi persetujuan ?"}))
		end
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(act.join(" "))		
			end
		end
	end

	def action course
		act = []
		if can? :read, course
			act << raw(link_to(content_tag(:i, "", class: "fa fa-book"), course, class: "btn btn-primary btn-xs"))
		end
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(act.join(" "))		
			end
		end
	end

	def course_supervisors course
		course.supervisors.includes(:lecturer).approved_supervisors.map do |supervisor|
			"<li>#{supervisor.lecturer.to_s}</li>"
		end.join("\n")
	end

	def total_records
		surceases = Surcease.includes(:provenable, {course: :student}).by_lecturer(current_user.userable_id)
		if params[:sSearch].present?
			query = params[:sSearch]
			surceases = surceases.search(query)
		end
		surceases
	end

	def fetch_surceases
		surceases = total_records.page(page).per_page(per_page)
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

end