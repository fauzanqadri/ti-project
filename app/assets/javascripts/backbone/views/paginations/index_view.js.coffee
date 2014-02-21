TiProject.Views.Paginations ||= {}
class TiProject.Views.Paginations.IndexView extends Backbone.View
	template: JST["backbone/templates/paginations/index"]

	tagName: "ul"
	className: "pager"

	events:
		'click #next' : 'nextData'
		'click #prev' : 'prevData'

	initialize: () ->

	nextData: (e) =>
		e.preventDefault()
		@options.return_action.next()

	prevData: (e) =>
		e.preventDefault()
		@options.return_action.prev()

	render: =>
		$(@el).html(@template(@options.page_info))
		return this