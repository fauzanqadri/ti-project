class TiProject.Routers.ConferencesRouter extends Backbone.Router
	routes:
		"index" : "index"
		".*"	: "index"

	initialize: (options) ->
		@scheduled_conferences = new TiProject.Collections.ConferenceCollections()
		@unscheduled_conferences = new TiProject.Collections.ConferenceCollections()
		@scheduled_conferences.url = $("#conferences").data('source')
		@unscheduled_conferences.url = $("#unscheduled-conferences").data('source')

	index: ->
		@view = new TiProject.Views.Conferences.IndexView(scheduled_conferences: @scheduled_conferences, selector: "#conferences", unscheduled_conferences: @unscheduled_conferences)
		@view.render()
		@scheduled_conferences.fetch(add: true)
		@unscheduled_conferences.fetch(add: true)