TiProject.Views.News ||= {}
class TiProject.Views.News.News extends Backbone.View
	template: JST["backbone/templates/news/news"]

	className: "panel panel-danger"

	render: =>
		$(@el).html(@template(@model.toJSON()))
		return this