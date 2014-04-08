class PostsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes'

	def initialize view
		@view = view
	end

	def posts
		@posts ||= fetch_posts
	end

	def as_json opt = {}
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: total_records.size,
			iTotalDisplayRecords: posts.total_entries,
			aaData: data
		}
	end

	def userable
		@userable ||= current_user.userable
	end

	private

	def data
		posts.map do |post|
			[
				post.title,
				post.created_at.try(:strftime, "%d %B %Y"),
				post.userable.to_s,
				post.boundable_type,
				boundable(post.boundable_type, post.boundable_id),
				publish_action(post),
				action(post)
			]
		end
	end

	def boundable type, id
		return type if id.nil? || id.blank?
		klass = type.constantize.find(id)
		return klass.name
	end

	def publish_action post
		btn_klass = post.publish? ? "btn-danger" : "btn-success"
		icon_klass = post.publish? ? "fa-times" : "fa-check"
		content_tag :div, :class => "text-center" do
			raw(link_to(content_tag(:i, "", :class => "fa #{icon_klass}"), url_helpers.publish_post_path(post), :class => "btn btn-xs #{btn_klass}", method: :post))
		end
	end

	def action post
		act = []
		act << raw(link_to(content_tag(:i, "", :class => "fa fa-eye"), url_helpers.view_post_path(post), :class => "btn btn-xs btn-default"))
		act << raw(link_to(content_tag(:i, "", :class => "fa fa-edit"), url_helpers.edit_post_path(post), :class => "btn btn-xs btn-primary", remote: true))
		act << raw(link_to(content_tag(:i, "", :class => "fa fa-trash-o"), post, :class => "btn btn-xs btn-danger", method: :delete, data: {confirm: "Konfirmasi Penghapusan ?"}))
		content_tag :div, :class => "text-center" do
			content_tag :div, :class => "btn-group" do
				raw(act.join(" "))		
			end
		end
	end

	def total_records
		posts = send(userable.class.to_s.downcase)
		posts = posts.order("#{sort_column} #{sort_direction}")
		if params[:sSearch].present?
			query = params[:sSearch]
			posts = posts.search(query)
		end
		posts
	end

	def fetch_posts
		posts = total_records.page(page).per_page(per_page)
		posts
	end

	def lecturer
		userable.posts.includes(:userable)
	end

	def staff
		Post.includes(:userable)
	end

	def student
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns =["title", "", "", "boundable_type", "", "publish"]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end


end