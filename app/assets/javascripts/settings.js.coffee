$(document).ready ->
	autoComplete = $("#department_director_name").autocomplete(
		minLength: 2
		autoFocus: true
		source: (req, resp) =>
			$.ajax
				url: $("#department_director_name").data('source')
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
		focus: (event, ui) =>
			$("#department_director_name").val(ui.item.label)
			$("#setting_department_director").val(ui.item.value)
			return false
		select: (event, ui) =>
			$("#department_director_name").val(ui.item.label)
			$("#setting_department_director").val(ui.item.value)
			return false
	).data("ui-autocomplete")

	autoComplete._renderItem = (ul, item) =>
		html = JST['templates/lecturer_search']
		return $(html(item)).appendTo(ul);

	anotherAutoComplete = $("#department_secretary_name").autocomplete(
		minLength: 2
		autoFocus: true
		source: (req, resp) =>
			$.ajax
				url: $("#department_secretary_name").data('source')
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
		focus: (event, ui) =>
			$("#department_secretary_name").val(ui.item.label)
			$("#setting_department_secretary").val(ui.item.value)
			return false
		select: (event, ui) =>
			$("#department_secretary_name").val(ui.item.label)
			$("#setting_department_secretary").val(ui.item.value)
			return false
	).data("ui-autocomplete")

	anotherAutoComplete._renderItem = (ul, item) =>
		html = JST['templates/lecturer_search']
		return $(html(item)).appendTo(ul);


