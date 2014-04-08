module MarkdownHelper

	class HTMLwithAlbino < Redcarpet::Render::HTML

		def initialize options = {}
			default_options = {
				autolink: true, 
				filter_html: true, 
				no_styles: true,
				safe_links_only: true,
				with_toc_data: true,
				hard_wrap: true
			}
			super default_options.merge(options)
		end

		def block_code(code, language)
			# super(code, language)
			CodeRay.scan(code, language).html(line_numbers: nil, wrap: :div, css: :style)
		end
	end

	def render_markdown text, options = {}
		html_markdown = markdown.render(text).html_safe
		return html_markdown if options.nil? || options.blank?
		omission = options[:omission] || '...(continued)'
		length = options[:length] || 150
		html_truncate(html_markdown, length: length, omission: omission)
	end

	private
	def markdown
		Redcarpet::Markdown.new(HTMLwithAlbino, fenced_code_blocks: true, tables: true)
	end

	def html_truncate html, options = {}
		return '' if html.nil? || html.blank?
		html_string = TruncateHtml::HtmlString.new(html)
		TruncateHtml::HtmlTruncator.new(html_string, options).truncate
	end

end