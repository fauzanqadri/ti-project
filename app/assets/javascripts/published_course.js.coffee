$(document).ready ->
	window.publishedCoursesRoute = new TiProject.Routers.PublishedCoursesRouter()
	try
		Backbone.history.start()
	catch e
		Backbone.history.stop()
		Backbone.history.start()