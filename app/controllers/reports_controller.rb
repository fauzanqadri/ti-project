class ReportsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  skip_before_filter :checking_setting!, only: :index
  skip_before_filter :checking_assessment!, only: :index
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  skip_load_resource only: [:create, :new]

  # GET /reports
  # GET /reports.json
  def index
    respond_to do |format|
      format.json { render json: ReportsDatatable.new(view_context)}
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    respond_to do |format|
      format.js
      format.html do
        if params[:download].present? && params[:download]
          send_file(@report.attachment.path, disposition: "attachment", type: @report.attachment_content_type)
        else
          send_file(@report.attachment.path, disposition: "inline", type: @report.attachment_content_type)
        end
      end
    end
  end

  # GET /reports/new
  def new
    @course = Course.find(course_id)
    @report = @course.reports.build
    authorize! :create, @report
    respond_to do |format|
      format.js
    end
  end

  # POST /reports
  # POST /reports.json
  def create
    @course = Course.find(course_id)
    @report = @course.reports.build(report_params)
    authorize! :create, @report
    respond_to do |format|
      if @report.save
        flash[:notice] = "Laporan tambahan berhasil dibuat, #{undo_link(@report)}"
        format.js
        format.json { render action: 'show', status: :created, location: @report }
      else
        format.js { render action: 'new' }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      flash[:notice] = "Laporan tambahan berhasil dihapus, #{undo_link(@report)}"
      format.html { redirect_to @course }
    end
  end

  private

  def set_report
    @course = Course.find(course_id)
    @report = @course.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:name, :course_id, :attachment)
  end

  def course_id
    course_id = params[:skripsi_id].present? ? params[:skripsi_id] : params[:pkl_id]
    course_id
  end

end
