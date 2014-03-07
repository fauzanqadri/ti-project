TiProject.Views.Conferences ||= {}
class TiProject.Views.Conferences.ModalView extends Backbone.View
	template: JST["backbone/templates/conferences/modal"]

	id: "sessionModal"
	className: "modal fade"

	events:
		'click input[type="checkbox"]' : 'approve'
		'click #add-examiner' : 'addExaminer'
		'click #set-local'	: 'setLocal'

	approve: (e) =>
		if @model.attributes.department_director_approval == true
			status = false
		else
			status = true

		@model.set({department_director_approval: status}).save null,
			success: @success

	addExaminer: (e) =>
		$("#examiners .examiners-form").empty()
		add_examiner_view = new TiProject.Views.Conferences.ExaminerFormView({model: @model, return_action: this})
		$(add_examiner_view.render().el).hide().appendTo("#examiners .examiners-form").fadeIn("slow")

	setLocal: (e) =>
		local = $("#local").val()
		if local
			@model.set({local: local}).save null,
				success: @success

	success: (conference) =>
		$(@el).modal('hide')
		@options.return_action.addOne(conference)
		
	render: ->
		$(@el).html(@template(@model.toFullJSON())).modal('show')
		return this