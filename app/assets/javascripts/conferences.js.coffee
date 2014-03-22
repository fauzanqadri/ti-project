$(document).ready ->
	window.conferencesRouter = new TiProject.Routers.ConferencesRouter()
	try
		Backbone.history.start()
	catch e
		Backbone.history.stop()
		Backbone.history.start()