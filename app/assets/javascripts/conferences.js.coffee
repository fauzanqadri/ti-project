$(document).ready ->
	$("#conferences").dataTable
		sPaginationType: "full_numbers"
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#conferences').data('source')
		sPaginationType: "bootstrap"
		aoColumnDefs: [
			bSortable: false,
			aTargets: [0, 1, 2, 3, 4, 5, 6]
		]
