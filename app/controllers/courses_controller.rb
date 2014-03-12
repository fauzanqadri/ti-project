class CoursesController < ApplicationController
	skip_before_filter :checking_setting!
	skip_before_filter :checking_assessment!
	load_and_authorize_resource
	
  def index
    # @courses = Course.all
    respond_to do |format|
      format.json {render json: CoursesDatatable.new(view_context)}
    end
  end
end
