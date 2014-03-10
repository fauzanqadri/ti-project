TiProject.Views.PublishedCourses ||= {}

class TiProject.Views.PublishedCourses.ConcentrationsView extends Backbone.View
	template: JST["backbone/templates/published_courses/concentrations_view"]

	initialize: () ->
		@options.concentrations.bind('reset', @addAll)

	addAll: =>
		@options.concentrations.each(@addOne)

	addOne: (concentration) =>
		view = new TiProject.Views.PublishedCourses.Concentration({model: concentration})
		$('#concentration').append(view.render().el)

	render: =>
		$(@el).html(@template())
		return this