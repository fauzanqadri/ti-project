class TiProject.Models.Course extends Backbone.Model
	paramRoot: 'course'

class TiProject.Collections.CoursesCollection extends Backbone.Collection
	model: TiProject.Models.Course
	url: "/courses"

	initialize: () ->
		typeof (options) isnt "undefined" or (options = {})
		@cPage = 1
		@cDisplayStart = 0
		@cTotalRecords = 0
		@cTotalDisplayRecords = 0
		@cDisplayLength = 10
		@cByCurrentUser = true
		@cSearch = ""
		@byType = ""
		@bySupervisor = ""
		@finish = ""

	parse: (data) ->
		@cPage = data.cPage
		@cTotalRecords = data.cTotalRecords
		@cTotalDisplayRecords = data.cTotalDisplayRecords
		return data.cData

	buildRequest: (params) ->
		if params instanceof Object
			@cDisplayLength = params.cDisplayLength
			@cDisplayStart = 0				
			unless typeof params.cByCurrentUser is 'undefined'
				@cByCurrentUser = params.cByCurrentUser
			unless typeof params.byType is 'undefined'
				@byType = params.byType
			unless typeof params.cSearch is 'undefined'
				@cSearch = params.cSearch
			unless typeof params.bySupervisor is 'undefined'
				@bySupervisor = params.bySupervisor
			unless typeof params.finish is 'undefined'
				@finish = params.finish			

	setDisplayStart: (strt) =>
		if typeof strt isnt "undefined"
			@cDisplayStart = strt

	fetch: (options)	=>
		options or (options = {})
		data = (options.data or {})
		requst_params =
			cDisplayLength: @cDisplayLength
			cDisplayStart: @cDisplayStart

		unless @cByCurrentUser is ""
			_.extend(requst_params, {cByCurrentUser: @cByCurrentUser})
		unless @cSearch is ""
			_.extend(requst_params, {cSearch: @cSearch})
		unless @byType is ""
			_.extend(requst_params, {byType: @byType})
		unless @bySupervisor is ""
			_.extend(requst_params, {bySupervisor: @bySupervisor})
		unless @finish is ""
			_.extend(requst_params, {finish: @finish})
		params = 
			reset: true
			data: $.param(requst_params)
		_.extend(options, params)
		Backbone.Collection::fetch.call this, options

	page_info: ()->
		res = 
			cTotalRecords: @cTotalRecords
			cPage: @cPage
			cDisplayLength: @cDisplayLength
			pages: Math.ceil(@cTotalRecords/@cDisplayLength)
			prev: false
			next: false
		max = Math.min(@cTotalRecords, @cPage * @cDisplayLength)
		max = @cTotalRecords if @cTotalRecords is @cPage * @cDisplayLength
		res.range = [(@cPage - 1) * @cDisplayLength + 1, max]
		res.prev = @cPage - 1 if @cPage > 1
		res.next = @cPage + 1 if @cPage < res.pages
		return res 

	nextPage: () ->
		return false unless @page_info().next
		@setDisplayStart(parseInt(@cDisplayStart) + parseInt(@cDisplayLength))
		return @fetch()

	previousPage: ()->
		return false unless @page_info().prev
		@setDisplayStart(parseInt(@cDisplayStart) - parseInt(@cDisplayLength))
		return @fetch()