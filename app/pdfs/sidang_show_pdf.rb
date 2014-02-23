class SidangShowPdf < Prawn::Document
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize view
		super(:page_size => "A4")
		@view = view
	end
end