class TiProject.Models.Feedback extends Backbone.Model
	paramRoot: 'feedback'

class TiProject.Collections.FeedbacksCollection extends Backbone.Collection
	model: TiProject.Models.Feedback

	initialize: () ->
		typeof (options) isnt "undefined" or (options = {})
		@cPage = 1
		@cDisplayStart = 0
		@cTotalRecords = 0
		@cTotalDisplayRecords = 0
		@cDisplayLength = 10
		# typeof(@cDisplayLength) != 'undefined' || (@cDisplayLength = 10);

	parse: (data) ->
		@cPage = data.cPage
		@cTotalRecords = data.cTotalRecords
		@cTotalDisplayRecords = data.cTotalDisplayRecords
		# console.log @length
		# console.log @cDisplayLength
		return data.cData

	setDisplayLength: (lng) =>
		if typeof lng isnt "undefined"
			@cDisplayLength = lng
			@cDisplayStart = 0

	setDisplayStart: (strt) =>
		if typeof strt isnt "undefined"
			@cDisplayStart = strt
		
	fetch: (options) =>
		options or (options = {})
		data = (options.data or {})
		params = 
			reset: true
			data: $.param({cDisplayLength: @cDisplayLength, cDisplayStart: @cDisplayStart})
		_.extend(options, params)
		# console.log options
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