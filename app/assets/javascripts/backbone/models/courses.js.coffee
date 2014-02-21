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

	parse: (data) ->
		@cPage = data.cPage
		@cTotalRecords = data.cTotalRecords
		@cTotalDisplayRecords = data.cTotalDisplayRecords
		return data.cData

	buildRequest: (params) ->
		if params instanceof Object
			@cDisplayLength = params.cDisplayLength
			@cByCurrentUser = params.cByCurrentUser
			@byType = params.byType
			@cSearch = params.cSearch
			@cDisplayStart = 0

	setDisplayStart: (strt) =>
		if typeof strt isnt "undefined"
			@cDisplayStart = strt

	fetch: (options)	=>
		options or (options = {})
		data = (options.data or {})
		params = 
			reset: true
			data: $.param({
				cDisplayLength: @cDisplayLength, 
				cDisplayStart: @cDisplayStart, 
				cByCurrentUser: @cByCurrentUser, 
				cSearch: @cSearch,
				byType: @byType
			})
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