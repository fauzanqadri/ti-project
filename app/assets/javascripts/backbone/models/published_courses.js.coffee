class TiProject.Models.PublishedCourse extends Backbone.Model
	paramRoot: 'published_course'

class TiProject.Collections.PublishedCourseCollection extends Backbone.Collection
	model: TiProject.Models.PublishedCourse
	url: '/published_courses'

	initialize: () ->
		typeof (options) isnt "undefined" or (options = {})
		@sEcho = 1
		@iDisplayStart = 0
		@iTotalRecords = 0
		@iTotalDisplayRecords = 0
		@iDisplayLength = 10
		@sSearch = ""
		@byType = ""
		@faculty_id = ""
		@department_id = ""
		@concentration_id = ""

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
			unless typeof params.byType is 'undefined'
				@byType = params.byType
			unless typeof params.faculty_id is 'undefined'
				@faculty_id = params.faculty_id
			unless typeof params.department_id is 'undefined'
				@department_id = params.department_id
			unless typeof params.concentration_id is 'undefined'
				@concentration_id = params.concentration_id

	fetch: (options)	=>
		options or (options = {})
		data = (options.data or {})
		request_param = 
			iDisplayLength: @iDisplayLength
			iDisplayStart: @iDisplayStart
		unless @sSearch is ""
			_.extend(request_param, {sSearch: @sSearch})
		unless @byType is ""
			_.extend(request_param, {byType: @byType})
		unless @faculty_id is ""
			_.extend(request_param, {faculty_id: @faculty_id})
		unless @department_id is ""
			_.extend(request_param, {department_id: @department_id})
		unless @concentration_id is ""
			_.extend(request_param, {concentration_id: @concentration_id})
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
