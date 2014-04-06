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
			CodeRay.scan(code, language).div(:line_numbers => :table)
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

	def html_redcarpet
		options = {
			autolink: true, 
			filter_html: true, 
			no_styles: true,
			safe_links_only: true,
			hard_wrap: true, 
		}
		Redcarpet::Render::HTML.new(options)
	end

	def syntax_highlighter(html)
  	doc = Nokogiri::HTML(html)
  	doc.search("//pre[@lang]").each do |pre|
    	pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  	end
  	doc.to_s
	end

end