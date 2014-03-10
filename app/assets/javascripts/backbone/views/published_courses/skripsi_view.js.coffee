TiProject.Views.PublishedCourses ||= {}

class TiProject.Views.PublishedCourses.SkripsiView extends Backbone.View
	template: JST["backbone/templates/published_courses/skripsi"]

	className: "panel panel-primary"

	render: ->
		$(@el).html(@template(@model.toJSON() ))
		return this
