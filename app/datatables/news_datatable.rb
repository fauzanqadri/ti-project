class NewsDatatable
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 
	include MarkdownHelper

	def initialize view
		@view = view
	end

	def news
		@news ||= fetch_news
	end

	def as_json opt = {}
		{
			sEcho: page,
			iTotalRecords: total_records.size,
			iTotalDisplayRecords: news.total_entries,
			aaData: data
		}
	end

	def userable
		@userable ||= current_user.userable
	end

	private

	def data
		news.map do |berita|
			{
				title: berita.title,
				content: render_markdown(berita.content, truncate: 200),
				created_at: berita.created_at.try(:strftime, "%d %B %Y"),
				boundery: boundery(berita.boundable_type, berita.boundable_id),
				userable: {fullname: berita.userable.to_s, type: berita.userable_type},
				action: act(berita)
			}
		end
	end

	def boundery(klass, id = nil)
		return {bound: klass, name: nil} if klass == "Global"
		return {bound: klass, name: nil} if id.nil?
		kls = klass.constantize
		name = kls.find(id).name
		{bound: klass, name: name}
	end

	def act berita
		acted = []
		acted << raw(link_to content_tag(:i, "", :class => "fa fa-eye") + " Detail", url_helpers.view_post_path(berita), class: "btn btn-primary" )
		content_tag :div, :class => "text-center" do
			raw(acted.join(" "))
		end
	end

	def total_records
		news = send(userable.class.to_s.downcase)
		if params[:sSearch].present?
			query = params[:sSearch]
			news = news.search(query)
		end
		news
	end

	def fetch_news
		news = total_records.page(page).per_page(per_page)
		news
	end

	def student
		Post.includes(:userable).accessible(userable.department.faculty_id, userable.department_id).published
	end

	def lecturer
		Post.includes(:userable).accessible(userable.department.faculty_id, userable.department_id).published
	end

	def staff
		Post.includes(:userable).published
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

end