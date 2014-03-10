class SeminarsController < ApplicationController
  before_action :set_seminar, only: [:show, :edit, :update, :edit_department_director_approval, :update_department_director_approval]
  load_and_authorize_resource
  skip_load_resource only: [:new, :create]

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

  def new
    @skripsi = Skripsi.find(params[:skripsi_id])
    @seminar = @skripsi.build_seminar
    authorize! :create, @seminar 
    respond_to do |format|
      format.js
    end
  end

  # POST /seminars
  # POST /seminars.json
  def create
    @skripsi = Skripsi.find(params[:skripsi_id])
    @seminar = @skripsi.build_seminar(register_params)
    @seminar.userable = current_user.userable
    authorize! :create, @seminar
    respond_to do |format|
      if @seminar.save
        flash[:notice] = 'Pendaftaran seminar berhasil dilakukan'
        format.js
        format.html { redirect_to @skripsi }
      else
        format.js {render action: 'new'}
        format.html { redirect_to @skripsi, alert: @seminar.errors.full_messages.join(", ") }
      end
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

  def edit_department_director_approval
    respond_to do |format|
      format.js
    end
  end

  def update_department_director_approval
    respond_to do |format|
      if @seminar.update(seminar_department_director_approval_params)
        notice_text = @seminar.department_director? && @seminar.undertake_plan.present? ? "Permohonan seminar berhasil disetujui" : "Permohonan seminar berhasil diubah"
        flash[:notice] = notice_text
        format.js
        format.json { head :no_content }
      else
        format.js { render action: 'edit_department_director_approval' }
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

    def seminar_department_director_approval_params
      params.require(:seminar).permit(:department_director, :undertake_plan)
    end

    def register_params
      params.require(:seminar).permit(:start)
    end
end
