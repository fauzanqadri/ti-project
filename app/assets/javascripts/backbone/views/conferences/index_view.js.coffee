TiProject.Views.Conferences ||= {}
class TiProject.Views.Conferences.IndexView extends Backbone.View
	template: JST["backbone/templates/conferences/index_view"]

	events:
		'keyup #sSearch' : "reload"
		'change #byType input': 'reload'
		"change #iDisplayLength" : 'changeLength'

	initialize: () ->
		@options.scheduled_conferences.bind('reset', @addAll)
		@options.unscheduled_conferences.bind('reset', @unscheduledConferencesAddAll)
		@options.unscheduled_conferences.bind('reset', @rerenderUnscheduledConferences)

	addAll: () =>
		$("#scheduled-conference").fullCalendar('removeEvents')
		@options.scheduled_conferences.each(@addOne)

	addOne: (item) =>
		$("#scheduled-conference").fullCalendar('removeEvents', item.id)
		$("#scheduled-conference").fullCalendar('renderEvent', item.toEventData(), true)

	unscheduledConferencesAddAll: () =>
		$("#unscheduled-conference .panel").each (i, e)->
			$(this).delay(i*1000).slideUp "fast", =>
				$(this).remove()
		@options.unscheduled_conferences.each(@unscheduledConferencesAddOne)
		pagination = new TiProject.Views.Paginations.IndexView(page_info: @options.unscheduled_conferences.page_info(), return_action: this)
		$("#paginate").append(pagination.render().el)

	unscheduledConferencesAddOne: (item) =>
		unscheduledConferencesView = new TiProject.Views.Conferences.UnscheduledView({model: item, return_action: this})
		$(unscheduledConferencesView.render().el).hide().appendTo("#unscheduled-conference")

	rerenderUnscheduledConferences: =>
		$("#unscheduled-conference .panel").each (i, e)->
			$(this).delay(i*1000).slideDown("fast")

	eventResizeDrop: (evt) =>
		model = @options.scheduled_conferences.get(evt.id)
		data = 
			start: evt.start.toStrMySQLDateTime()
			end: evt.end.toStrMySQLDateTime()
		model.set(data).save null,
			success: @addOne

	eventClick: (evt) =>
		model = @options.scheduled_conferences.get(evt.id)			
		modal = new TiProject.Views.Conferences.ModalView({model: model, return_action: this})
		$('body').append(modal.render().el)

	externalDrop: (date, allDay, evt) =>
		id = $(evt.target).data('eventObject')
		end = new Date(date.getTime() + 60*60000)
		model = @options.unscheduled_conferences.get(id)
		model.set({start: date.toStrMySQLDateTime(), end: end.toStrMySQLDateTime()}).save(
			null,
			success: @extSuccess
		)

	buildParams: ()=>
		type = $("#byType input[type=\"radio\"]:checked").val()
		iDisplayLength = $("#iDisplayLength").val()
		query = $("#sSearch").val()
		params =
			byType: type
			iDisplayLength: iDisplayLength

		if sSearch
			_.extend(params, {sSearch: query})
		return params


	extSuccess: (item) =>
		$($("#unscheduled-conference .panel").data("eventObject", item.id)).remove()
		@reload()

	changeLength: =>
		@options.unscheduled_conferences.buildRequest(@buildParams())
		@options.unscheduled_conferences.fetch()

	theConference: =>
		conferencesType = $("#byConference input[type=\"radio\"]:checked").val()
		if conferencesType is 'scheduled'
			return @options.scheduled_conferences
		else if conferencesType is 'unscheduled'
			return @options.unscheduled_conferences
		else
			return [@options.scheduled_conferences, @options.unscheduled_conferences]

	reload: =>
		if @theConference() instanceof Array
			i = 0
			while i < @theConference().length
				@theConference()[i].buildRequest(@buildParams())
				@theConference()[i].fetch()
				i++
		else
			@theConference().buildRequest(@buildParams())
			@theConference().fetch()
	
	next: () =>
		@options.unscheduled_conferences.nextPage()

	prev: ()=>
		@options.unscheduled_conferences.previousPage()

	render: =>
		html = $(@el).html(@template())
		$(html).appendTo("#conferences")
		$("#scheduled-conference").fullCalendar(
			header: 
				left: 'prev,next today'
				center: 'title'
				right: 'month,agendaWeek,agendaDay'
			selectable: true
			selectHelper: true
			editable: true
			droppable: true
			dropAccept: '.cool-event'
			monthNames: ['Januari', 'Februari', 'Maret', 'April', 'May', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember']
			dayNames: ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
			dayNamesShort: ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
			eventResize: @eventResizeDrop
			eventDrop: @eventResizeDrop
			eventClick: @eventClick
			drop: @externalDrop
		)
		return this