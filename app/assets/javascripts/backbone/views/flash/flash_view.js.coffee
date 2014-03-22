TiProject.Views.Flash ||= {}

class TiProject.Views.Flash.FlashView extends Backbone.View
	template: JST["backbone/templates/flash/flash_view"]
	className: =>
		res = 
			"alert":"alert-danger"
			"notice":"alert-success"
			"warning":"alert-warning"
		return "alert " + res[@options.config.status]

	icon: (status) =>
		res =
			"alert":"fa-exclamation-triangle"
			"notice":"fa-check"
			"warning":"fa-flag"
		return res[status]

	messageParams: ()->
		params = 
			message: @options.config.message
			icon: @icon(@options.config.status)
			status: @options.config.status.charAt(0).toUpperCase() + @options.config.status.slice(1)
		return params


	render: () ->
		$(@el).html(@template(@messageParams()))
		return this
