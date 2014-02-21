$(document).ready ->
	$("#paper").dataTable
		sPaginationType: "two_button"
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#paper').data('source')
		sPaginationType: "bootstrap"
		bFilter: false
		bInfo: false
		bPaginate: false
		aoColumnDefs: [
			bSortable: false,
			aTargets: [1]
		]

	$("#supervisor").dataTable
		sPaginationType: "two_button"
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#supervisor').data('source')
		sPaginationType: "bootstrap"
		bFilter: false
		bInfo: false
		bPaginate: false
		aoColumnDefs: [
			bSortable: false,
			aTargets: [1]
		]
	$("#supervisorWaiting").dataTable
		sPaginationType: "two_button"
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#supervisorWaiting').data('source')
		sPaginationType: "bootstrap"
		bFilter: false
		bInfo: false
		bPaginate: false
		aoColumnDefs: [
			bSortable: false,
			aTargets: [1]
		]

	$("#consultation").dataTable
		sPaginationType: "full_numbers"
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#consultation').data('source')
		sPaginationType: "bootstrap"
		aoColumnDefs: [
			bSortable: false,
			aTargets: [1, 2, 4, 5]
		]

	window.feedbacksRoute = new TiProject.Routers.FeedbacksRouter()
	try
		Backbone.history.start()
	catch e
		Backbone.history.stop()
		Backbone.history.start()

