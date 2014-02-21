TiProject.Views.Feedbacks ||= {}
class TiProject.Views.Feedbacks.IndexView extends Backbone.View
	template: JST["backbone/templates/feedbacks/index"]

	events:
		"change #cDisplayLength" : 'changeDisplayLength'

	initialize: () ->
		# @template = JST["backbone/templates/feedbacks/index"]
		@options.feedbacks.bind('reset', @addAll)

	addAll: ()=>
		$("#feedbacks section ul.media-list").empty()
		@options.feedbacks.each(@addOne)
		$("#paginate").empty()
		pagination = new TiProject.Views.Paginations.IndexView(page_info: @options.feedbacks.page_info(), return_action: this)
		$("#paginate").append(pagination.render().el)

	addOne: (feedback) =>
		view = new TiProject.Views.Feedbacks.FeedbackView({model: feedback})
		$("#feedbacks section ul.media-list").append(view.render().el)
	
	data: (options) =>
		cDisplayLength = $("#cDisplayLength").val()
		params =
			cDisplayLength: cDisplayLength
		if typeof options isnt "undefined" and options instanceof Object
			_.extend(params, options)
		res = 
			data: $.param(params)
		return res

	changeDisplayLength: () =>
		cDisplayLength = $("#cDisplayLength").val()
		@options.feedbacks.setDisplayLength(cDisplayLength)
		@options.feedbacks.fetch();
		# @reload()

	reload: (params) =>
		data = (if typeof params isnt 'undefined' and params instanceof Object then params else @data())
		@options.feedbacks.fetch(data)

	next: () =>
		@options.feedbacks.nextPage()

	prev: ()=>
		@options.feedbacks.previousPage()

	render: =>
		$(@el).html(@template())
		return this