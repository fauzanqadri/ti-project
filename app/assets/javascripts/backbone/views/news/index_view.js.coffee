TiProject.Views.News ||= {}
class TiProject.Views.News.IndexView extends Backbone.View
	template: JST["backbone/templates/news/index"]

	events:
		'keyup #search'	: 'filter'
		'change #iDisplayLength' : 'filter'

	initialize: () ->
		@options.collections.bind('reset', @addAll)

	addAll: () =>
		$("#news-list .result-info").empty();
		$("#news-list .result").empty();
		$("#paginate").empty()
		@options.collections.each(@addOne)
		res_info = new TiProject.Views.PageInfo.IndexView(page_info: @options.collections.page_info())
		pagination = new TiProject.Views.Paginations.IndexView(page_info: @options.collections.page_info(), return_action: this)
		$("#news-list .result-info").append(res_info.render().el)
		$("#paginate").append(pagination.render().el)

	addOne: (model) =>
		view = new TiProject.Views.News.News({model: model})
		$(view.render().el).appendTo("#news-list .result")

	buildParams: ()=>
		iDisplayLength = $("#iDisplayLength").val()
		search = $("#search").val()
		params =
			iDisplayLength: iDisplayLength
		unless typeof search is "undefined" or search is ""
			_.extend(params, {query: search})
		params

	filter: () =>
		@options.collections.buildRequest(@buildParams())
		@options.collections.fetch()

	next: () =>
		@options.collections.nextPage()

	prev: ()=>
		@options.collections.previousPage()

	render: =>
		$(@el).html(@template())
		return this