TiProject.Views.Conferences ||= {}
class TiProject.Views.Conferences.IndexView extends Backbone.View

	initialize: () ->
		@options.scheduled_conferences.bind('reset', @addOne)
		@options.scheduled_conferences.bind('add', @addOne)
		@options.unscheduled_conferences.bind('reset', @unscheduledConferencesAddOne)
		@options.unscheduled_conferences.bind('add', @unscheduledConferencesAddOne)

	addAll: () =>
		$(@options.selector).fullCalendar('addEventSource', @options.scheduled_conferences.toJSON())

	addOne: (item) =>
		$(@options.selector).fullCalendar('removeEvents', item.id)
		$(@options.selector).fullCalendar('renderEvent', item.toEventData(), true)

	unscheduledConferencesAddOne: (item) =>
		$($("#unscheduled-conferences .panel").data("eventObject", 40)).slideUp "slow", () ->
			$(this).remove()
		unscheduledConferencesView = new TiProject.Views.Conferences.UnscheduledView({model: item, return_action: this})
		$(unscheduledConferencesView.render().el).hide().appendTo("#unscheduled-conferences").slideDown('slow')

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

	externalDrop: (evt) =>
		console.log "dropped"

	render: =>
		$(@options.selector).fullCalendar(
			weekends: false
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
