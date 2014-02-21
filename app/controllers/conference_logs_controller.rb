class ConferenceLogsController < ApplicationController

  # GET /conference_logs
  # GET /conference_logs.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: ConferenceLogsDatatable.new(view_context)}
    end
    # @conference_logs = ConferenceLog.all
  end

  def approve
    @conference_log = ConferenceLog.find(params[:id])
    if @conference_log.approve?
      redirect_to conference_logs_url, notice: "Berhasil menyetujui permohonan pendaftaran #{@conference_log.conference.type}"
    else
      redirect_to conference_logs_url, alert: "Ermmm, Contact Ketua Prodi"
    end
  end

end
