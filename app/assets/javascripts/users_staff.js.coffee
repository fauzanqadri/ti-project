$(document).ready ->
	$("#posts").dataTable
		sPaginationType: "full_numbers"
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#posts').data('source')
		sPaginationType: "bootstrap"
		aoColumnDefs: [
			bSortable: false,
			aTargets: [1, 2, 4, 6]
		]