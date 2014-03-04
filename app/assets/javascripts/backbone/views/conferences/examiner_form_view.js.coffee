TiProject.Views.Conferences ||= {}
class TiProject.Views.Conferences.ExaminerFormView extends Backbone.View
	template: JST["backbone/templates/conferences/examiner_form"]

	className: "form-group"

	events:
		'click #submit' : 'addExaminer'

	addExaminer: (e)=>
		lecturer_id = $("#lecturer_id").val()
		data = 
			examiners_attributes: [lecturer_id: lecturer_id]
		@model.set(data).save(null, success: @success)

	success: (conference) =>
		delete conference.attributes['examiners_attributes']
		@options.return_action.unscheduledConferencesAddOne(conference)

	render: =>
		$(@el).html(@template())
		examiners_name = $($(@el).find("#examiners_name")[0])
		autoComplete = examiners_name.autocomplete(
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
								supervisors_pkl_count: item.supervisors_pkl_count

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
			html = "<li data-value=\""+item.value+"\"><a><div class=\"row\"><div class=\"col-sm-3\"><img class=\"img-circle img-thumbnail\" src=\"http://placehold.it/50x50\"></div><div class=\"col-sm-9\"><blockquote><p>"+item.label+"<br/><div class=\"label-group\"><span class=\"label label-primary\"><i class=\"fa fa-book\"></i> Skripsi : "+item.supervisors_skripsi_count+"</span><span class=\"label label-success\"><i class=\"fa fa-file\"></i> Pkl :"+item.supervisors_pkl_count+"</span></div></p></blockquote></div></div></a></li>"
			return $(html).appendTo(ul)
		return this