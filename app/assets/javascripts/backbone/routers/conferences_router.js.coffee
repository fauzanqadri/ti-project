class TiProject.Routers.ConferencesRouter extends Backbone.Router
	routes:
		"index" : "index"
		".*"	: "index"

	initialize: (options) ->
		@scheduled_conferences = new TiProject.Collections.ConferenceCollections()
		@unscheduled_conferences = new TiProject.Collections.ConferenceCollections()
		@scheduled_conferences.url = $("#conferences").data('scheduled')
		@unscheduled_conferences.url = $("#conferences").data('unscheduled')

	index: ->
		@view = new TiProject.Views.Conferences.IndexView(scheduled_conferences: @scheduled_conferences, unscheduled_conferences: @unscheduled_conferences)
		@view.render()
		@view.reload()