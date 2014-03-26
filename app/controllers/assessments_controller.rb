class AssessmentsController < ApplicationController
  skip_before_filter :checking_setting!
  skip_before_filter :checking_assessment!
  before_action :set_department, except: :index
  load_and_authorize_resource
  skip_load_resource only: [:create]

  # GET /assessments
  # GET /assessments.json
  def index
    respond_to do |format|
      format.html
      format.json {render json: AssessmentsDatatable.new(view_context)}
    end
  end

  # GET /assessments/new
  def new
    @assessment = @department.assessments.build
    respond_to do |format|
      format.js
    end
  end

  # GET /assessments/1/edit
  def edit
    @assessment = @department.assessments.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /assessments
  # POST /assessments.json
  def create
    @assessment = @department.assessments.build(assessment_params)
    authorize! :create, @assessment
    respond_to do |format|
      if @assessment.save
        flash[:notice] = "Aspek Penilaian berhasil ditambahkan, #{undo_link(@assessments)}"
        format.js
      else
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /assessments/1
  # PATCH/PUT /assessments/1.json
  def update
    @assessment = @department.assessments.find(params[:id])
    respond_to do |format|
      if @assessment.update(assessment_params)
        flash[:notice] = "Aspek Penilaian berhasil diubah, #{undo_link(@assessments)}"
        format.js
      else
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /assessments/1
  # DELETE /assessments/1.json
  def destroy
    @assessment = @department.assessments.find(params[:id])
    @assessment.destroy
    respond_to do |format|
      flash[:notice] = "Aspek Penilaian berhasil dihapus, #{undo_link(@assessments)}"
      format.html { redirect_to assessments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = current_user.userable.department
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assessment_params
      params.require(:assessment).permit(:aspect, :percentage, :category)
    end
end
