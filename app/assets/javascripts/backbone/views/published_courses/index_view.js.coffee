TiProject.Views.PublishedCourses ||= {}

class TiProject.Views.PublishedCourses.IndexView extends Backbone.View
	template: JST["backbone/templates/published_courses/index"]

	events: 
		'change #faculty' : 'changeFaculty'
		'change #department' : 'changeDepartment'
		'change #concentration' : 'changeConcentration'
		'keyup #query'	: 'filter'
		'change #type input': 'filter'
		'change #iDisplayLength' : 'filter'

	initialize: () ->
		@options.collections.bind('reset', @addAll)
		@initFaculty()

	addAll: () =>
		$("#course-list .result-info").empty()
		$("#course-list .result").empty()
		$("#paginate").empty()
		@options.collections.each(@addOne)
		res_info = new TiProject.Views.PageInfo.IndexView(page_info: @options.collections.page_info())
		pagination = new TiProject.Views.Paginations.IndexView(page_info: @options.collections.page_info(), return_action: this)
		$("#course-list .result-info").append(res_info.render().el)
		$("#paginate").append(pagination.render().el)

	addOne: (model) =>
		if model.attributes.type == "Skripsi"
			view = new TiProject.Views.PublishedCourses.SkripsiView({model: model})
		else
			view = new TiProject.Views.PublishedCourses.PklView({model: model})
		$(view.render().el).appendTo("#course-list .result")

	initFaculty: () =>
		@faculties = new TiProject.Collections.FacultiesCollection()
		@faculties.bind('reset', @addAllFaculty)
		@fetchFaculties()

	fetchFaculties: =>
		@faculties.fetch()

	addAllFaculty: =>
		@faculties.each(@addOneFaculty)

	addOneFaculty: (faculty) =>
		view = new TiProject.Views.PublishedCourses.Faculty({model: faculty})
		$(view.render().el).appendTo($(@el).find('#faculty')[0])

	changeFaculty: (e) =>
		faculty_id = $(e.target).find("option:selected").val()
		$("#departments, #concentrations").hide()
		$("#departments, #concentrations").empty()
		@filter()
		unless faculty_id is ""
			@departments = new TiProject.Collections.DepartmentsCollection()
			@departments.url = '/get_departments/' + faculty_id
			@renderDepartment()
		
	renderDepartment: () =>
		view = new TiProject.Views.PublishedCourses.DepartmentsView(departments: @departments)
		$("#departments").append(view.render().el).show()
		@departments.fetch()

	changeDepartment: (e) =>
		department_id = $(e.target).find('option:selected').val()
		$("#concentrations").hide()
		$("#concentrations").empty()
		@filter()
		unless department_id is ""
			@concentrations = new TiProject.Collections.ConcentrationsCollection()
			@concentrations.url = '/get_concentrations/' + department_id
			@renderConcentration()

	renderConcentration: () =>
		view = new TiProject.Views.PublishedCourses.ConcentrationsView(concentrations: @concentrations)
		$("#concentrations").append(view.render().el).show()
		@concentrations.fetch()

	changeConcentration: (e) =>
		concentration_id = $(e.target).find('option:selected').val()
		@filter()

	buildParams: ()=>
		iDisplayLength = $("#iDisplayLength").val()
		query = $("#query").val()
		type = $("#type input[type=\"radio\"]:checked").val()
		faculty_id = $("#faculty").find("option:selected").val()
		department_id = $("#department").find('option:selected').val()
		concentration_id = $("#concentration").find('option:selected').val()
		params =
			iDisplayLength: iDisplayLength
		unless typeof query is "undefined" or query is ""
			_.extend(params, {query: query})
		unless typeof type is 'undefined' or type is ""
			_.extend(params, {byType: type})

		unless typeof faculty_id is 'undefined' or faculty_id is ""
			_.extend(params, {faculty_id: faculty_id})
		else
			_.extend(params, {faculty_id: ""})

		unless typeof department_id is 'undefined' or department_id is ""
			_.extend(params, {department_id: department_id})
		else
			_.extend(params, {department_id: ""})

		unless typeof concentration_id is 'undefined' or concentration_id is ""
			_.extend(params, {concentration_id: concentration_id})
		else
			_.extend(params, {concentration_id: ""})
		params
		
	filter: =>
		@options.collections.buildRequest(@buildParams())
		@options.collections.fetch()

	next: () =>
		@options.collections.nextPage()

	prev: ()=>
		@options.collections.previousPage()

	render: =>
		$(@el).html(@template())
		return this