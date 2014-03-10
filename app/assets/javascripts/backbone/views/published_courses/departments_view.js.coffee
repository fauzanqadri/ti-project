TiProject.Views.PublishedCourses ||= {}

class TiProject.Views.PublishedCourses.DepartmentsView extends Backbone.View
	template: JST["backbone/templates/published_courses/departments_view"]

	initialize: () ->
		@options.departments.bind('reset', @addAll)

	addAll: =>
		@options.departments.each(@addOne)

	addOne: (department) =>
		view = new TiProject.Views.PublishedCourses.Department({model: department})
		$('#department').append(view.render().el)

	render: =>
		$(@el).html(@template())
		return this