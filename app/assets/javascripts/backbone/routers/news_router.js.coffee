class TiProject.Routers.NewsRouter extends Backbone.Router
	routes:
		"index" : "index"
		".*"	: "index"

	initialize: (options) ->
		@news = new TiProject.Collections.NewsCollection()

	index: ->
		@view = new TiProject.Views.News.IndexView(collections: @news)
		$("#news").append(@view.render().el)
		@view.filter()