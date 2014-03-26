class PklAssessmentsController < ApplicationController
  skip_before_filter :checking_setting!
  skip_before_filter :checking_assessment!
  before_action :set_department, except: :index
  before_action :set_pkl_assessment, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  skip_load_resource only: [:create]

  # GET /pkl_assessments
  # GET /pkl_assessments.json
  def index
    if params[:pkl_id].present?
      @pkl = Pkl.find(params[:pkl_id])
    end
    respond_to do |format|
      format.html
      format.json {render json: PklAssessmentsDatatable.new(view_context)}
      format.js
      format.pdf do
        pdf = PklAssessmentsPdf.new(view_context)
        if params[:download]
          send_data pdf.render, type: "application/pdf", disposition: "attachment", filename: "Laporan_Penilaian_Pkl.pdf"
        else
          send_data pdf.render, type: "application/pdf", disposition: "inline", filename: "Laporan_Penilaian_Pkl.pdf"
        end
      end
    end
  end

  # GET /pkl_assessments/1
  # GET /pkl_assessments/1.json
  def show
  end

  # GET /pkl_assessments/new
  def new
    @pkl_assessment = @department.pkl_assessments.build
    respond_to do |format|
      format.js
    end
  end

  # GET /pkl_assessments/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /pkl_assessments
  # POST /pkl_assessments.json
  def create
    @pkl_assessment = @department.pkl_assessments.build(pkl_assessment_params)
    @pkl_assessment.department_id = current_user.userable.department_id
    authorize! :create, @pkl_assessment
    respond_to do |format|
      if @pkl_assessment.save
        flash[:notice] = "Record aspek penilaian pkl berhasil dibuat, #{undo_link(@pkl_assessment)}"
        format.js
        format.json { render action: 'show', status: :created, location: @pkl_assessment }
      else
        format.js {render action: 'new'}
        format.json { render json: @pkl_assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pkl_assessments/1
  # PATCH/PUT /pkl_assessments/1.json
  def update
    respond_to do |format|
      if @pkl_assessment.update(pkl_assessment_params)
        flash[:notice] = "Record aspek penilaian pkl berhasil diubah, #{undo_link(@pkl_assessment)}"
        format.js
        format.json { head :no_content }
      else
        format.js { render action: 'edit' }
        format.json { render json: @pkl_assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pkl_assessments/1
  # DELETE /pkl_assessments/1.json
  def destroy
    @pkl_assessment.destroy
    respond_to do |format|
      flash[:notice] = "Record aspek penilaian pkl berhasil dihapus, #{undo_link(@pkl_assessment)}"
      format.html { redirect_to pkl_assessments_url }
      format.json { head :no_content }
    end
  end
  

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_pkl_assessment
    @pkl_assessment = @department.pkl_assessments.find(params[:id])
  end

  def set_department
    @department = current_user.userable.department
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pkl_assessment_params
    params.require(:pkl_assessment).permit(:aspect, :percentage, :category)
  end
end
