class TiProject.Models.Conference extends Backbone.Model
	paramRoot: 'conference'

	url: =>
		return "/conferences/" + @id

	toFullJSON: =>
		_.clone(@attributes)

	toJSON: =>
		data = _.pick(@attributes, 'start', 'end', 'local', 'department_director_approval', 'examiners_attributes')
		return data

	toEventData: =>
		data = _.pick(@attributes, 'id', 'start', 'end', 'color')
		if typeof(@attributes) isnt 'undefinded'
			local = (if not @attributes.local? then "-" else @attributes.local)
			data["title"] = @attributes.type+" "+local
			if @attributes.start isnt null
				data["allDay"] = false
			else
				data["allDay"] = true
				
		return data

class TiProject.Collections.ConferenceCollections extends Backbone.Collection
	model: TiProject.Models.Conference

	initialize: () ->
		typeof (options) isnt "undefined" or (options = {})
		@sEcho = 1
		@iDisplayStart = 0
		@iTotalRecords = 0
		@iTotalDisplayRecords = 0
		@iDisplayLength = 10
		@sSearch = ""
		@byType = ""


	parse: (data) ->
		@sEcho = data.sEcho
		@iTotalRecords = data.iTotalRecords
		@iTotalDisplayRecords = data.iTotalDisplayRecords
		return data.aaData

	buildRequest: (params) ->
		if params instanceof Object
			@iDisplayLength = params.iDisplayLength
			@byType = params.byType
			@sSearch = params.sSearch
			@iDisplayStart = 0

	setDisplayStart: (strt) =>
		if typeof strt isnt "undefined"
			@iDisplayStart = strt

	fetch: (options)	=>
		options or (options = {})
		data = (options.data or {})
		params = 
			reset: true
			data: $.param({
				sEcho: @sEcho,
				iDisplayLength: @iDisplayLength, 
				iDisplayStart: @iDisplayStart, 
				sSearch: @sSearch,
				byType: @byType
			})
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