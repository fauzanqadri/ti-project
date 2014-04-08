$(document).ready ->
	window.newsRoute = new TiProject.Routers.NewsRouter()
	try
		Backbone.history.start()
	catch e
		Backbone.history.stop()
		Backbone.history.start()