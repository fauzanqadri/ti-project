TiProject.Views.Courses ||= {}

class TiProject.Views.Courses.PaginationView extends Backbone.View
	template: JST["backbone/templates/courses/pagination"]

	tagName: "li"

	events:
		'click a' : "clicked"

	initialize: () ->
		if typeof @options.pageInfo.active isnt "undefined" and @options.pageInfo.active is true
			$(@el).addClass('active')

	clicked: (e)=>
		e.preventDefault()
		if $(e.target).parent().attr('class') isnt 'active'
			number = parseInt($(e.target).text())
			@options.returnAction.changePage(number)
			

	render: () ->
		$(@el).html(@template(@options.pageInfo))
		return this
