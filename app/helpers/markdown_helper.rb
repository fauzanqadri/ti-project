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
			# Pygments.css('.highlight')
			# Pygments.css()
			# Pygments.highlight(code, :lexer => language, :style => "monokai")
		end
	end

	def render_markdown text
		markdown.render(text)
	end

	private
	def markdown
		# Redcarpet::Markdown.new(HTMLwithAlbino)
		Redcarpet::Markdown.new(HTMLwithAlbino, fenced_code_blocks: true, tables: true)
	end

	def html_redcarpet
		options = {
			autolink: true, 
			filter_html: true, 
			no_styles: true,
			safe_links_only: true,
			# with_toc_data: true,
			hard_wrap: true, 
			# fenced_code_blocks: true
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