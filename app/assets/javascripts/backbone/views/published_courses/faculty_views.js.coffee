TiProject.Views.PublishedCourses ||= {}

class TiProject.Views.PublishedCourses.Faculty extends Backbone.View
	template: JST["backbone/templates/published_courses/faculty_views"]

	tagName: "option"

	render: =>
		$(@el).attr('value', @model.attributes.id)
		$(@el).html(@template(@model.toJSON() ))
		return this

