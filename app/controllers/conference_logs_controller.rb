class ConferenceLogsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:approve]

  # GET /conference_logs
  # GET /conference_logs.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: ConferenceLogsDatatable.new(view_context)}
    end
  end

  def approve
    @conference_log = ConferenceLog.find(params[:id])
    authorize! :approve, @conference_log
    if @conference_log.approve?
      redirect_to conference_logs_url, notice: "Berhasil menyetujui permohonan pendaftaran #{@conference_log.conference.type}, #{undo_link(@conference_log)}"
    else
      redirect_to conference_logs_url, alert: "Ermmm, Contact Ketua Prodi"
    end
  end

end
