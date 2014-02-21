$(document).ready ->
	window.courseRoute = new TiProject.Routers.CoursesRouter()
	try
		Backbone.history.start()
	catch e
		Backbone.history.stop()
		Backbone.history.start()


	# $("#user-skripsi-filter").on "click", ->
	# 	$("#tabMenu a:first").data("type", "Skripsi")
	# 	$("#tabMenu a:first").tab('show')

	# $("#user-pkl-filter").on "click", ->
	# 	$("#tabMenu a:first").data("type", "Pkl")
	# 	$("#tabMenu a:first").tab('show')
