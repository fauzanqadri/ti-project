$(document).ready ->
	$("#waiting_approval").dataTable
		sPaginationType: "full_numbers"
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#waiting_approval').data('source')
		sPaginationType: "bootstrap"
		aoColumnDefs: [
			bSortable: false,
			iDataSort: 2
			aTargets: [0, 1, 4]
		]