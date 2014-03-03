class TiProject.Routers.ConferencesRouter extends Backbone.Router
	routes:
		"index" : "index"
		".*"	: "index"

	initialize: (options) ->
		@conferences = new TiProject.Collections.ConferenceCollections()

	index: ->
		@view = new TiProject.Views.Conferences.IndexView(conferences: @conferences, selector: "#conferences")
		@view.render()
		@conferences.fetch(add: true)