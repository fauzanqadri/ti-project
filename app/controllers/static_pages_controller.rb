class StaticPagesController < ApplicationController
	skip_before_filter :authenticate_user!, only: [:published_courses, :get_faculties, :get_departments, :get_concentrations]

	def index
		render template: "static_pages/#{current_user.userable_type.downcase}"
	end

	def published_courses
		respond_to do |format|
			format.html
			format.json {render json: PublishedCoursesDatatable.new(view_context)}
		end
	end

	def get_faculties
		@faculties = Faculty.all
	end

	def get_departments
		@faculty = Faculty.find(params[:faculty_id])
		@departments = @faculty.departments
	end

	def get_concentrations
		@department = Department.find(params[:department_id])
		@concentrations = @department.concentrations
	end

end
