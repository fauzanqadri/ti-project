$(document).ready ->
	$("#pkl-assessments").dataTable
		sPaginationType: "full_numbers"
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#pkl-assessments').data('source')
		sPaginationType: "bootstrap"
		aoColumnDefs: [
			bSortable: false,
			aTargets: [0, 3]
		]
