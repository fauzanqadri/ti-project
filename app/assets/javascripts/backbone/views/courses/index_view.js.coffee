TiProject.Views.Courses ||= {}
class TiProject.Views.Courses.IndexView extends Backbone.View
	template: JST["backbone/templates/courses/index"]

	events:
		'shown.bs.dropdown #dropdown' : 'dropdownOpen'
		'click #dropdown .dropdown-toggle' : 'dropdownClick'
		'hide.bs.dropdown #dropdown' : 'dropdownHide'
		'click #tabMenu > li > a' : 'changeType'
		
		'change #cDisplayLength' : 'filter'
		'keyup #cSearch' : 'filter'
		'keyup #bySupervisor' : 'filter'
		'shown.bs.tab' : 'filter'
		'change #filter input' : 'filter'
		'change #supervisorApproval input' : 'filter'

	initialize: () ->
		@options.selfCourses.bind('reset', @selfCoursesAddAll)
		@options.otherCourses.bind('reset', @otherCoursesAddAll)

	dropdownOpen: (e) ->
		$("#dropdown").data('closable', false)

	dropdownClick: (e) ->
		$("#dropdown").data('closable', true)

	dropdownHide: (e) ->
		$("#dropdown").data('closable')

	selfCoursesAddAll: () =>
		$("#byCurrentUser .result").empty()
		$("#byCurrentUser .result-info").empty()
		$("#paginate").empty()
		@options.selfCourses.each(@selfCoursesaddOne)
		res_info = new TiProject.Views.PageInfo.IndexView(page_info: @options.selfCourses.page_info())
		pagination = new TiProject.Views.Paginations.IndexView(page_info: @options.selfCourses.page_info(), return_action: this)
		$("#byCurrentUser .result-info").append(res_info.render().el)
		$("#paginate").append(pagination.render().el)

	otherCoursesAddAll: () =>
		$("#byDepartment .result").empty()
		$("#byDepartment .result-info").empty()
		$("#paginate").empty()
		@options.otherCourses.each(@otherCoursesaddOne)
		pagination = new TiProject.Views.Paginations.IndexView(page_info: @options.otherCourses.page_info(), return_action: this)
		res_info = new TiProject.Views.PageInfo.IndexView(page_info: @options.otherCourses.page_info())
		$("#byDepartment .result-info").append(res_info.render().el)
		$("#paginate").append(pagination.render().el)

	selfCoursesaddOne: (course) =>
		if course.attributes.type == "Skripsi"
			view = new TiProject.Views.Courses.SkripsiView({model: course})
		else
			view = new TiProject.Views.Courses.PklView({model: course})
		$("#byCurrentUser .result").append(view.render().el)

	otherCoursesaddOne: (course) =>
		if course.attributes.type == "Skripsi"
			view = new TiProject.Views.Courses.SkripsiView({model: course})
		else
			view = new TiProject.Views.Courses.PklView({model: course})
		$("#byDepartment .result").append(view.render().el)

	filter: () =>
		cDisplayLength = $("#cDisplayLength").val()
		tabActive = $($("#tabMenu").find("li.active")[0]).data('bycurrentuser')
		cSearch = $("#cSearch").val() 
		bySupervisor = $("#bySupervisor").val()
		type = $("#filter input[type=\"radio\"]:checked").val()
			
		params =
			cDisplayLength: cDisplayLength
			cByCurrentUser: tabActive
			cSearch: cSearch
			bySupervisor: bySupervisor
		if typeof type isnt "undefined" and type isnt "on"
			_.extend(params, {byType: type})		 

		if typeof options isnt "undefined" and options instanceof Object
			_.extend(params, options)
			
		@theCourse().buildRequest(params)
		@theCourse().fetch()

	changeType: (e) =>
		e.preventDefault()
		$(e.target).tab('show')

	theCourse: () =>
		tabActive = $($("#tabMenu").find("li.active")[0]).data('bycurrentuser')
		if tabActive
			@options.selfCourses
		else
			@options.otherCourses

	next: () =>
		@theCourse().nextPage()

	prev: ()=>
		@theCourse().previousPage()

	render: =>
		$(@el).html(@template())
		return this