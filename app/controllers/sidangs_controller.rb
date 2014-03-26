class SidangsController < ApplicationController
  before_action :set_sidang, only: [:show, :edit, :update]
  load_and_authorize_resource
  skip_load_resource only: [:create]

  # GET /sidangs/1
  # GET /sidangs/1.json
  def show
    respond_to do |format|
      format.js
      format.pdf do
        pdf = SidangShowPdf.new(view_context)
        if params[:download]
          send_data pdf.render, type: "application/pdf", disposition: "attachment", filename: "Laporan_Sidang.pdf"
        else
          send_data pdf.render, type: "application/pdf", disposition: "inline", filename: "Laporan_Sidang.pdf"
        end
      end
    end
  end

  # GET /sidangs/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /sidangs
  # POST /sidangs.json
  def create
    @skripsi = Skripsi.find(params[:skripsi_id])
    @sidang = @skripsi.build_sidang
    @sidang.userable = current_user.userable
    authorize! :create, @sidang
    if @sidang.save
      redirect_to @skripsi, notice: "Pendaftaran sidang berhasil dilakukan, #{undo_link(@sidang)}"
    else
      redirect_to @skripsi, alert: @sidang.errors.full_messages.join(", ")
    end
  end

  # PATCH/PUT /sidangs/1
  # PATCH/PUT /sidangs/1.json
  def update
    respond_to do |format|
      if @sidang.update(sidang_params)
        format.html { redirect_to @sidang, notice: "Sidang was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sidang.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sidangs/1
  # DELETE /sidangs/1.json

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sidang
      @skripsi = Skripsi.find(params[:skripsi_id])
      @sidang = @skripsi.sidang
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sidang_params
      params.require(:sidang).permit(:local, :start, :end)
    end
end
