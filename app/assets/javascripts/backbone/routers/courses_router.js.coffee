class TiProject.Routers.CoursesRouter extends Backbone.Router
	routes:
		"index" : "index"
		".*"	: "index"

	initialize: (options) ->
		@selfCourses = new TiProject.Collections.CoursesCollection()
		@otherCourses = new TiProject.Collections.CoursesCollection()

	index: ->
		@view = new TiProject.Views.Courses.IndexView(selector: "#courses", selfCourses: @selfCourses, otherCourses: @otherCourses)
		$("#courses").append(@view.render().el)
		@view.theCourse().fetch()