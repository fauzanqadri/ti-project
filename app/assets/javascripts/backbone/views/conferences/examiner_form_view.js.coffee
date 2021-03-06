TiProject.Views.Conferences ||= {}
class TiProject.Views.Conferences.ExaminerFormView extends Backbone.View
	template: JST["backbone/templates/conferences/examiner_form"]

	className: "form-horizontal"

	events:
		'click #submit' : 'addExaminer'

	addExaminer: (e)=>
		lecturer_id = $("#lecturer_id").val()
		data = 
			examiners_attributes: [lecturer_id: lecturer_id]
		@model.set(data).save(null, success: @success)

	success: (conference) =>
		delete conference.attributes['examiners_attributes']
		@options.return_action.success(conference)

	render: =>
		$(@el).html(@template())
		examiners_name = $($(@el).find("#examiners_name")[0])
		autoComplete = examiners_name.autocomplete(
			appendTo: @el
			minLength: 2
			autoFocus: true
			source: (req, resp) =>
				$.ajax
					url: '/lecturers/search'
					dataType: "json"
					data: {query: req.term}
					success: (data) =>
						resp( $.map data, (item) =>
							return {
								value: item.id,
								label: item.full_name,
								supervisors_skripsi_count: item.supervisors_skripsi_count,
								supervisors_pkl_count: item.supervisors_pkl_count,
								photo: item.photo,
								level: item.level

							}
						)
			focus: (evt, ui) =>
				$(evt.target).val(ui.item.label)
				$("#lecturer_id").val(ui.item.value)
				return false
			select: (evt, ui) =>
				$(evt.target).val(ui.item.label)
				$("#lecturer_id").val(ui.item.value)
				return false
		).data("ui-autocomplete")

		autoComplete._renderItem = (ul, item) =>
			html = JST['templates/lecturer_search']
			return $(html(item)).appendTo(ul)
		return this