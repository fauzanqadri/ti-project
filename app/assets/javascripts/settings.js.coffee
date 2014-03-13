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
							photo: item.photo

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
		html = "<li data-value=\""+item.value+"\"><a><div class=\"row\"><div class=\"col-sm-3\"><img class=\"img-circle img-thumbnail\" src=\""+item.photo+"\"></div><div class=\"col-sm-9\"><blockquote><p>"+item.label+"<br/><div class=\"label-group\"><span class=\"label label-primary\"><i class=\"fa fa-book\"></i> Skripsi : "+item.supervisors_skripsi_count+"</span><span class=\"label label-success\"><i class=\"fa fa-file\"></i> Pkl :"+item.supervisors_pkl_count+"</span></div></p></blockquote></div></div></a></li>";
		return $(html).appendTo(ul);

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
							photo: item.photo

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
		html = "<li data-value=\""+item.value+"\"><a><div class=\"row\"><div class=\"col-sm-3\"><img class=\"img-circle img-thumbnail\" src=\""+item.photo+"\"></div><div class=\"col-sm-9\"><blockquote><p>"+item.label+"<br/><div class=\"label-group\"><span class=\"label label-primary\"><i class=\"fa fa-book\"></i> Skripsi : "+item.supervisors_skripsi_count+"</span><span class=\"label label-success\"><i class=\"fa fa-file\"></i> Pkl :"+item.supervisors_pkl_count+"</span></div></p></blockquote></div></div></a></li>";
		return $(html).appendTo(ul);


