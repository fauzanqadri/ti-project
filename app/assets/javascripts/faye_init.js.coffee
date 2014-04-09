class FayeWebSocket

	constructor: ->
		http = location.protocol
		url = http.concat("//").concat(window.location.hostname).concat(":9292/faye")
		@faye = new Faye.Client(url)
		@faye.subscribe("/main_channel", @message)

	message: (data) =>
		if data instanceof Object
			unless typeof data["type"] is 'undefined'
				if data["type"] == 'private'
					@private_message(data)
				else
					@[data['command']](data['args'])	
			else
				@[data['command']](data['args'])
		else
			throw "You sending non Object data, and Object must be contain command and args as a key"

	private_message: (data) =>
		unique_identification = $("#identification-unique").val()
		@[data['command']](data['args']) if typeof data['socket_identifier'] isnt 'undefined' and data['socket_identifier'] is unique_identification

	renderFlash: (options) =>
		@playSound()
		flash = new TiProject.Views.Flash.FlashView(config: options)
		$(flash.render().el).hide().appendTo("#the-flash")
		$("#the-flash .alert").each (i, e)->
			$(@).delay(i*1000).fadeIn("slow")
		
	playSound: () =>
		@stopSound()
		$('body').append('<audio id="sound"><source src="/notif_audio.mp3" type="audio/mp3"/></audio>')
		document.getElementById('sound').play()

	stopSound: () =>
		$('#sound').remove()

window.faye_delegator = new FayeWebSocket()