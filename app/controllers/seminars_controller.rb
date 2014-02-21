class SeminarsController < ApplicationController
  before_action :set_seminar, only: [:show, :edit, :update]

  def index
    @skripsi = Skripsi.find(params[:skripsi_id])
    @seminar = @skripsi.seminar
    respond_to do |format|
      format.js
      format.pdf do
        pdf = SeminarShowPdf.new(view_context)
        send_data pdf.render, type: "application/pdf", disposition: "inline", filename: "Laporan_Seminar.pdf"
      end
    end
  end

  # GET /seminars/1
  # GET /seminars/1.json
  def show
    respond_to do |format|
      format.js
      format.pdf do
        pdf = SeminarShowPdf.new(view_context)
        if params[:download]
          send_data pdf.render, type: "application/pdf", disposition: "attachment", filename: "Laporan_Seminar.pdf"
        else
          send_data pdf.render, type: "application/pdf", disposition: "inline", filename: "Laporan_Seminar.pdf"
        end
      end
    end
  end


  # GET /seminars/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /seminars
  # POST /seminars.json
  def create
    @skripsi = Skripsi.find(params[:skripsi_id])
    @seminar = @skripsi.build_seminar
    @seminar.userable = current_user.userable
    if @seminar.save
      redirect_to @skripsi, notice: 'Pendaftaran seminar berhasil dilakukan'
    else
      redirect_to @skripsi, alert: @seminar.errors.full_messages.join(", ")
    end
  end

  # PATCH/PUT /seminars/1
  # PATCH/PUT /seminars/1.json
  def update
    respond_to do |format|
      if @seminar.update(seminar_params)
        format.html { redirect_to @seminar, notice: 'Seminar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @seminar.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seminar
      @skripsi = Skripsi.find(params[:skripsi_id])
      @seminar = @skripsi.seminar
      # @seminar = Seminar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def seminar_params
      params.require(:seminar).permit(:local, :start, :end)
    end
end
