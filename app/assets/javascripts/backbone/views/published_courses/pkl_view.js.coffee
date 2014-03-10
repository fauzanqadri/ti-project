TiProject.Views.PublishedCourses ||= {}

class TiProject.Views.PublishedCourses.PklView extends Backbone.View
	template: JST["backbone/templates/published_courses/pkl"]

	className: "panel panel-success"

	render: ->
		$(@el).html(@template(@model.toJSON() ))
		return this
