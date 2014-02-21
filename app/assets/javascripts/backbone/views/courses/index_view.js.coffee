TiProject.Views.Courses ||= {}
class TiProject.Views.Courses.IndexView extends Backbone.View
	template: JST["backbone/templates/courses/index"]

	events:
		"change #cDisplayLength" : 'filter'
		'keyup #cSearch' : "filter"
		'click #tabMenu > li > a' : 'changeType'
		'shown.bs.tab' : 'shown'
		'change #filter input': 'filter'

	initialize: () ->
		@options.selfCourses.bind('reset', @selfCoursesAddAll)
		@options.otherCourses.bind('reset', @otherCoursesAddAll)

	selfCoursesAddAll: () =>
		$("#byCurrentUser").empty()
		@options.selfCourses.each(@selfCoursesaddOne)
		$("#paginate").empty()
		pagination = new TiProject.Views.Paginations.IndexView(page_info: @options.selfCourses.page_info(), return_action: this)
		$("#paginate").append(pagination.render().el)

	otherCoursesAddAll: () =>
		$("#byDepartment").empty()
		@options.otherCourses.each(@otherCoursesaddOne)
		$("#paginate").empty()
		pagination = new TiProject.Views.Paginations.IndexView(page_info: @options.otherCourses.page_info(), return_action: this)
		$("#paginate").append(pagination.render().el)

	selfCoursesaddOne: (course) =>
		if course.attributes.type == "Skripsi"
			view = new TiProject.Views.Courses.SkripsiView({model: course})
		else
			view = new TiProject.Views.Courses.PklView({model: course})
		$("#byCurrentUser").append(view.render().el)

	otherCoursesaddOne: (course) =>
		if course.attributes.type == "Skripsi"
			view = new TiProject.Views.Courses.SkripsiView({model: course})
		else
			view = new TiProject.Views.Courses.PklView({model: course})
		$("#byDepartment").append(view.render().el)

	filter: () =>
		cSearch = $("#cSearch").val() 
		cDisplayLength = $("#cDisplayLength").val()
		tabActive = $($("#tabMenu").find("li.active")[0]).data('bycurrentuser')
		params =
			cDisplayLength: cDisplayLength
			cByCurrentUser: tabActive
		type = $("#filter input[type=\"radio\"]:checked").val()

		if typeof type isnt "undefined" and type isnt "on"
			_.extend(params, {byType: type})
		else
			_.extend(params, {byType: ""})

		if cSearch != ""
		 	_.extend(params, {cSearch: cSearch})
		else
		 	_.extend(params, {cSearch: ""})


		if typeof options isnt "undefined" and options instanceof Object
			_.extend(params, options)

		@theCourse().buildRequest(params)
		@theCourse().fetch()

	changeType: (e) =>
		e.preventDefault()
		$(e.target).tab('show')

	shown: (e) =>
		# @reload()
		@filter()

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

	reload: (params) =>
		tabActive = $($("#tabMenu").find("li.active")[0]).data('bycurrentuser')
		data = (if typeof params isnt 'undefined' and params instanceof Object then params else @data())
		if tabActive
			@options.selfCourses.fetch(data)
		else
			@options.otherCourses.fetch(data)

	render: =>
		$(@el).html(@template())
		return this