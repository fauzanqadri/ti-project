$(document).ready ->
	$("#imports").dataTable
		sPaginationType: "full_numbers"
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#imports').data('source')
		sPaginationType: "bootstrap"
		aoColumnDefs: [
			bSortable: false,
			aTargets: [1, 5, 8]
		]
