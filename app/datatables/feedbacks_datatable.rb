class FeedbacksDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes'
	include MarkdownHelper

	def initialize view
		@view = view
	end

	def feedbacks
		@feedbacks ||= fetch_feedbacks
	end

	def course
		@course ||= Course.find(course_id)
	end

	def as_json opt = {}
		{
			cPage: page,
			cTotalRecords: course.feedbacks.size,
			cTotalDisplayRecords: feedbacks.total_entries,
			cData: data
		}
	end

	private
	

	def act feedback
		action = []
		feedback_path = course.type == "Skripsi" ? url_helpers.skripsi_feedback_path(course, feedback) : url_helpers.pkl_feedback_path(course, feedback)
		if can? :destroy, feedback
			action << raw(link_to(content_tag(:i, "", :class => "fa fa-trash-o") + " Hapus", feedback_path, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		end
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(action.join(" "))		
			end
		end
	end

	def data
		feedbacks.map do |feedback|
			{
				content: render_markdown(feedback.content),
				created_at: feedback.created_at.to_formatted_s(:long_ordinal),
				userable: { 
					full_name: feedback.userable.to_s, 
					type: feedback.userable_type,
					photo: feedback.userable.avatar.image.url(:small)
				},
				action: act(feedback)
			}
		end
	end


	def fetch_feedbacks
		feedbacks = course.feedbacks.includes(userable: :avatar).order("created_at desc")
		feedbacks = feedbacks.page(page).per_page(per_page)
		feedbacks
	end

	def page
		params[:cDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:cDisplayLength].to_i > 0 ? params[:cDisplayLength].to_i : 10
	end

	def course_id
		return params[:skripsi_id] if params[:skripsi_id].present?
		return params[:pkl_id]
	end
end