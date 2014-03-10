class TiProject.Routers.PublishedCoursesRouter extends Backbone.Router
	routes:
		"index" : "index"
		".*"	: "index"

	initialize: (options) ->
		@published_courses = new TiProject.Collections.PublishedCourseCollection()

	index: ->
		@view = new TiProject.Views.PublishedCourses.IndexView(collections: @published_courses)
		$("#published_course").append(@view.render().el)
		@view.filter()
		# @published_courses.fetch()