TiProject.Views.PublishedCourses ||= {}

class TiProject.Views.PublishedCourses.Concentration extends Backbone.View
	template: JST["backbone/templates/published_courses/concentration"]

	tagName: "option"

	render: =>
		$(@el).attr('value', @model.attributes.id)
		$(@el).html(@template(@model.toJSON() ))
		return this

