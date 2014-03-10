$(document).ready ->
	$("#surceases").dataTable
		sPaginationType: "full_numbers"
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#surceases').data('source')
		sPaginationType: "bootstrap"
		aoColumnDefs: [
			bSortable: false,
			aTargets: [0, 1, 2, 3, 4, 5, 6]
		]
