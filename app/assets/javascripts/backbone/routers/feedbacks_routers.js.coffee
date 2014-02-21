class TiProject.Routers.FeedbacksRouter extends Backbone.Router
	routes:
		"index" : "index"
		".*"	: "index"

	initialize: (options) ->
		@feedbacks = new TiProject.Collections.FeedbacksCollection()
		url = $("#feedbacks").data("source")
		@feedbacks.url = url

	index: ->
		@feedbacks.fetch()
		@view = new TiProject.Views.Feedbacks.IndexView(feedbacks: @feedbacks)
		$("#feedbacks header").after(@view.render().el)
		
		