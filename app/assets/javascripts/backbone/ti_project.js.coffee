#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.TiProject =
	Models: {}
	Collections: {}
	Routers: {}
	Views: {}

	run: ->
		try
			Backbone.history.start()
		catch e
			Backbone.history.stop()
			Backbone.history.start()