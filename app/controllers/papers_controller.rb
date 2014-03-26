class PapersController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  skip_before_filter :checking_setting!, only: :index
  skip_before_filter :checking_assessment!, only: :index
  before_action :set_paper, only: [:show, :destroy]
  load_and_authorize_resource
  skip_load_resource only: [:create, :new]
  # GET /papers
  # GET /papers.json
  def index
    respond_to do |format|
      format.json {render json: PapersDatatable.new(view_context)}
    end 
  end

  # GET /papers/1
  # GET /papers/1.json
  def show
    respond_to do |format|
      format.js
      format.pdf do
        if params[:download]
          send_file(@paper.bundle.path, disposition: "attachment", type: @paper.bundle_content_type)
        else
          send_file(@paper.bundle.path, disposition: "inline", type: @paper.bundle_content_type)
        end
      end
    end
  end

  # GET /papers/new
  def new
    @course = Course.find(course_id)
    @paper = @course.papers.build
    authorize! :create, @paper
    respond_to do |format|
      format.js
    end
  end

  # POST /papers
  # POST /papers.json
  def create
    @course = Course.find(course_id)
    @paper = @course.papers.build(paper_params)
    authorize! :create, @paper
    respond_to do |format|
      if @paper.save
        flash[:notice] = "File berhasil ditambahkan, #{undo_link(@paper)}"
        format.js
        format.json { render action: 'show', status: :created, location: @paper }
      else
        format.js { render action: 'new' }
        format.json { render json: @paper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /papers/1
  # DELETE /papers/1.json
  def destroy
    @paper.destroy
    respond_to do |format|
      flash[:notice] = "File berhasil dihapus, #{undo_link(@paper)}"
      format.html { redirect_to @course }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paper
      @course = Course.find(course_id)
      @paper = @course.papers.find(params[:id])
    end

    def course_id
      return params[:skripsi_id] if params[:skripsi_id].present?
      return params[:pkl_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paper_params
      params.require(:paper).permit(:name, :bundle)
    end
end
