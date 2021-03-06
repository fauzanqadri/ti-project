TiProject.Views.Conferences ||= {}
class TiProject.Views.Conferences.UnscheduledView extends Backbone.View
	template: JST["backbone/templates/conferences/unscheduled_conference"]

	className: =>
		if @model.attributes.department_director_approval == true
			klas = "panel panel-primary"
		else
			klas = "panel panel-warning"
		if @model.attributes.manage_conference_scheduling == true
			return klas + " cool-event"
		else
			return klas
		

	events:
		'click input[type="checkbox"]' : 'approve'
		'click #add-examiner' : 'addExaminer'		

	initialize: () ->
		$(@el).data('eventObject', @model.id)

	approve: (e) =>
		if @model.attributes.department_director_approval == true
			status = false
		else
			status = true
		@model.set({department_director_approval: status}).save null,
			success: @success

	success: (conference) =>
		@model = conference
		$(@el).slideUp 'slow', =>
			$(@el).remove()
			@options.return_action.unscheduledConferencesAddOne(@model)
			@options.return_action.rerenderUnscheduledConferences()

	addExaminer: (e) =>
		$("#examiners .examiners-form").empty()
		add_examiner_view = new TiProject.Views.Conferences.ExaminerFormView({model: @model, return_action: this})
		$(add_examiner_view.render().el).hide().appendTo("#examiners .examiners-form").fadeIn("slow")

	render: =>
		$(@el).draggable
			zIndex: 999
			opacity: 0.4
			revert: true
			revertDuration: 0
		$(@el).html(@template(@model.toFullJSON() ))
		return this