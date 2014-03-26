class FacultiesController < ApplicationController
  before_action :set_faculty, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  skip_load_resource only: [:create]

  # GET /faculties
  # GET /faculties.json
  def index
    respond_to do |format|
      format.html
      format.json {render json: FacultiesDatatable.new(view_context)}
    end
    # @faculties = Faculty.all
  end

  # GET /faculties/1
  # GET /faculties/1.json
  def show
  end

  # GET /faculties/new
  def new
    @faculty = Faculty.new
    respond_to do |format|
      format.js
    end
  end

  # GET /faculties/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /faculties
  # POST /faculties.json
  def create
    @faculty = Faculty.new(faculty_params)
    authorize! :create, @faculty
    respond_to do |format|
      if @faculty.save
        flash[:notice] = "Record fakultas berhasil dibuat, #{undo_link(@faculty)}"
        format.json { render action: 'show', status: :created, location: @faculty }
        format.js
      else
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
        format.js {render action: 'new'}
      end
    end
  end

  # PATCH/PUT /faculties/1
  # PATCH/PUT /faculties/1.json
  def update
    respond_to do |format|
      if @faculty.update(faculty_params)
        flash[:notice] = "Record fakultas berhasil diubah, #{undo_link(@faculty)}"
        format.html { redirect_to faculties_path }
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /faculties/1
  # DELETE /faculties/1.json
  def destroy
    @faculty.destroy
    respond_to do |format|
      flash[:notice] = "Record fakultas berhasil dihapus, #{undo_link(@faculty)}"
      format.html { redirect_to faculties_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_faculty
    @faculty = Faculty.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def faculty_params
    params.require(:faculty).permit(:name, :description, :website)
  end

end
