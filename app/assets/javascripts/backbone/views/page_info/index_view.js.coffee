TiProject.Views.PageInfo ||= {}
class TiProject.Views.PageInfo.IndexView extends Backbone.View
	template: JST["backbone/templates/page_info/index"]
	className: "page-info"


	render: =>
		$(@el).html(@template(@options.page_info))
		return this