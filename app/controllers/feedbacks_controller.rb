class FeedbacksController < ApplicationController
  skip_before_filter :authenticate_user!, only: :index
  skip_before_filter :checking_setting!, only: :index
  skip_before_filter :checking_assessment!
  before_action :set_feedback, only: :destroy
  load_and_authorize_resource
  skip_load_resource only: [:create, :new]

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    # @feedbacks = Feedback.all
    respond_to do |format|
      format.json {render json: FeedbacksDatatable.new(view_context)}
    end
  end


  # GET /feedbacks/new
  def new
    @course = Course.find(course_id)
    @feedback = @course.feedbacks.build
    @feedback.userable = current_user.userable
    authorize! :create, @feedback
    respond_to do |format|
      format.js
    end
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @course = Course.find(course_id)
    @feedback = @course.feedbacks.build(feedback_params)
    @feedback.userable = current_user.userable
    authorize! :create, @feedback
    respond_to do |format|
      if @feedback.save
        flash[:notice] = "Feedback berhasil dibuat"
        format.js
        format.json { render action: 'show', status: :created, location: @feedback }
      else
        format.js { render action: 'new'}
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to @course }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @course = Course.find(course_id)
      @feedback = @course.feedbacks.find(params[:id])
    end

    def course_id
      return params[:skripsi_id] if params[:skripsi_id].present?
      return params[:pkl_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:content)
    end
end
