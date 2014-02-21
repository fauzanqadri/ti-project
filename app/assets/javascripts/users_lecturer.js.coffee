$(document).ready ->
	window.courseRoute = new TiProject.Routers.CoursesRouter()
	try
		Backbone.history.start()
	catch e
		Backbone.history.stop()
		Backbone.history.start()