class ConsultationsController < ApplicationController
  skip_before_filter :authenticate_user!, only: :index
  before_action :set_consultation, only: [:edit, :update, :destroy]
  load_and_authorize_resource
  skip_load_resource only: [:create, :new]
  # GET /consultations
  # GET /consultations.json
  def index
    @course = Course.find(course_id)
    respond_to do |format|
      format.json {render json: ConsultationsDatatable.new(view_context)}
      format.js
      format.pdf do
        pdf = ConsultationIndexPdf.new(view_context)
        if params[:download]
          send_data pdf.render, type: "application/pdf", disposition: "attachment", filename: "Catatan_Bimbingan.pdf"
        else
          send_data pdf.render, type: "application/pdf", disposition: "inline", filename: "Catatan_Bimbingan.pdf"
        end
      end
    end
  end

  # GET /consultations/new
  def new
    @course = Course.find(course_id)
    @consultation = @course.consultations.build
    supervisor = @course.supervisors.find_by_lecturer_id(current_user.userable_id)
    @consultation.consultable = supervisor
    authorize! :new, @consultation
    respond_to do |format|
      format.js
    end
  end

  # GET /consultations/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /consultations
  # POST /consultations.json
  def create
    @course = Course.find(course_id)
    @consultation = @course.consultations.build(consultation_params)
    supervisor = @course.supervisors.find_by_lecturer_id(current_user.userable_id)
    @consultation.consultable = supervisor
    authorize! :create, @consultation
    respond_to do |format|
      if @consultation.save
        flash[:notice] = "Catatan bimbingan berhasil dibuat"
        format.js
        # format.html { redirect_to @consultation, notice: 'Consultation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @consultation }
      else
        format.js { render action: 'new' }
        format.json { render json: @consultation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consultations/1
  # PATCH/PUT /consultations/1.json
  def update
    respond_to do |format|
      if @consultation.update(consultation_params)
        flash[:notice] = "Catatan bimbingan berhasil diupdate"
        format.js
      else
        format.js { render action: 'edit' }
        format.json { render json: @consultation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consultations/1
  # DELETE /consultations/1.json
  def destroy
    @consultation.destroy
    respond_to do |format|
      format.html { redirect_to @course }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consultation
      @course = Course.find(course_id)
      @consultation = @course.consultations.find(params[:id])
    end

    def course_id
      return params[:skripsi_id] if params[:skripsi_id].present?
      return params[:pkl_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consultation_params
      params.require(:consultation).permit(:content, :next_consult)
    end
end
