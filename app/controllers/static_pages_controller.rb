class StaticPagesController < ApplicationController

	def index
		render template: "static_pages/#{current_user.userable_type.downcase}"
	end
end
