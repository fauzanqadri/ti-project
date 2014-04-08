class TiProject.Models.News extends Backbone.Model
	paramRoot: 'course'

class TiProject.Collections.NewsCollection extends Backbone.Collection
	model: TiProject.Models.News
	url: "/news"

	initialize: () ->
		typeof (options) isnt "undefined" or (options = {})
		@sEcho = 1
		@iDisplayStart = 0
		@iTotalRecords = 0
		@iTotalDisplayRecords = 0
		@iDisplayLength = 10
		@sSearch = ""

	parse: (data) ->
		@sEcho = data.sEcho
		@iTotalRecords = data.iTotalRecords
		@iTotalDisplayRecords = data.iTotalDisplayRecords
		return data.aaData

	setDisplayStart: (strt) =>
		if typeof strt isnt "undefined"
			@iDisplayStart = strt

	buildRequest: (params) ->
		if params instanceof Object
			@iDisplayLength = params.iDisplayLength
			@iDisplayStart = 0
			unless typeof params.query is 'undefined'
				@sSearch = params.query

	fetch: (options)	=>
		options or (options = {})
		data = (options.data or {})
		request_param = 
			iDisplayLength: @iDisplayLength
			iDisplayStart: @iDisplayStart
		unless @sSearch is ""
			_.extend(request_param, {sSearch: @sSearch})
		params = 
			reset: true
			data: $.param(request_param)
		_.extend(options, params)
		Backbone.Collection::fetch.call this, options

	page_info: ()->
		res = 
			iTotalRecords: @iTotalRecords
			sEcho: @sEcho
			iDisplayLength: @iDisplayLength
			pages: Math.ceil(@iTotalRecords/@iDisplayLength)
			prev: false
			next: false
		max = Math.min(@iTotalRecords, @sEcho * @iDisplayLength)
		max = @iTotalRecords if @iTotalRecords is @sEcho * @iDisplayLength
		res.range = [(@sEcho - 1) * @iDisplayLength + 1, max]
		res.prev = @sEcho - 1 if @sEcho > 1
		res.next = @sEcho + 1 if @sEcho < res.pages
		return res 

	nextPage: () ->
		return false unless @page_info().next
		@setDisplayStart(parseInt(@iDisplayStart) + parseInt(@iDisplayLength))
		return @fetch()

	previousPage: ()->
		return false unless @page_info().prev
		@setDisplayStart(parseInt(@iDisplayStart) - parseInt(@iDisplayLength))
		return @fetch()
