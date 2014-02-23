$(document).ready ->
	$("#conference").dataTable
		bPaginate: false
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#conference').data('source')
		bFilter: false
		bInfo: false
		aoColumnDefs: [
			bSortable: false,
			aTargets: [0 ,1, 2, 3, 4, 5, 6]
		]

