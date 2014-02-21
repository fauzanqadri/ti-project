TiProject.Views.Feedbacks ||= {}
class TiProject.Views.Feedbacks.FeedbackView extends Backbone.View
	template: JST["backbone/templates/feedbacks/feedback"]

	tagName: "li"
	className: "media box"

	render: ->
		$(@el).html(@template(@model.toJSON() ))
		return this