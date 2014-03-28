class ConferencesController < ApplicationController
  skip_before_filter :authenticate_user!, only: :index
  skip_before_filter :checking_setting!, only: :index
  skip_before_filter :checking_assessment!, only: :index
  before_action :set_conference, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /conferences
  # GET /conferences.json
  def index
    respond_to do |format|
      format.html
      format.json do 
        render json: ConferencesDatatable.new(view_context)
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /conferences/1
  # PATCH/PUT /conferences/1.json
  def update
    respond_to do |format|
      if @conference.update(conference_params)
        format.js
        format.json
      else
        format.js { render action: 'edit' }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  def unmanaged_conferences
    respond_to do |format|
      format.html
      format.json do 
        render json: UnmanagedConferencesDatatable.new(view_context)
      end
    end
  end

  def conferences_report
    respond_to do |format|
      format.js
    end
  end

  def scheduled_conferences_report
    @report_params = params[:conference_report]
    respond_to do |format|
      format.js
    end
  end

  def show_conferences_report
    pdf = ScheduledConferencesReportPdf.new(view_context)
    respond_to do |format|
      format.pdf do
        if params[:download].present? && params[:download] == 'true'
          send_data pdf.render, type: "application/pdf", disposition: "attachment", filename: "Laporan_Penjadwalan_Seminar_Sidang.pdf"
        else
          send_data pdf.render, type: "application/pdf", disposition: "inline", filename: "Laporan_Penjadwalan_Seminar_Sidang.pdf"
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conference
      @conference = Conference.includes(skripsi: {supervisors: :lecturer}).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conference_params
      params.require(:conference).permit(:local, :start, :end, :department_director_approval, examiners_attributes: [:id, :lecturer_id])
      # if params[:sidang].present?
      #   return params.require(:sidang).permit(:local, :start, :end, examiners_attributes: [:id, :lecturer_id])
      # end
      # return params.require(:seminar).permit(:local, :start, :end, :department_director_approval)
    end
end
