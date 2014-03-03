TiProject.Views.Conferences ||= {}
class TiProject.Views.Conferences.IndexView extends Backbone.View

	initialize: () ->
		@options.conferences.bind('reset', @addOne)
		@options.conferences.bind('add', @addOne)

	addAll: () =>
		$(@options.selector).fullCalendar('addEventSource', @options.conferences.toJSON())

	addOne: (item) =>
		console.log "invoked"
		$(@options.selector).fullCalendar('removeEvents', item.id)
		$(@options.selector).fullCalendar('renderEvent', item.toEventData(), true)

	eventResizeDrop: (evt) =>
		console.log evt.start
		model = @options.conferences.get(evt.id)
		data = 
			start: evt.start.toStrMySQLDateTime()
			end: evt.end.toStrMySQLDateTime()
		model.set(data).save null,
			success: @addOne

	eventClick: (evt) =>
		model = @options.conferences.get(evt.id)			
		modal = new TiProject.Views.Conferences.ModalView({model: model, return_action: this})
		$('body').append(modal.render().el)

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
			monthNames: ['Januari', 'Februari', 'Maret', 'April', 'May', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember']
			dayNames: ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
			dayNamesShort: ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
			eventResize: @eventResizeDrop
			eventDrop: @eventResizeDrop
			eventClick: @eventClick
		)
