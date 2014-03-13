class LecturersController < ApplicationController
  skip_before_filter :checking_setting!
  skip_before_filter :checking_assessment!
  before_action :set_lecturer, only: [:show, :edit, :update, :destroy, :reset_password]
  load_and_authorize_resource
  skip_load_resource only: [:create]

  # GET /lecturers
  # GET /lecturers.json
  def index
    # @lecturers = Lecturer.all
    respond_to do |format|
      format.html
      format.json {render json: LecturersDatatable.new(view_context)}
    end
  end

  # GET /lecturers/1
  # GET /lecturers/1.json
  def show
    respond_to do |format|
      format.js
    end
  end

  # GET /lecturers/new
  def new
    @lecturer = Lecturer.new
    respond_to do |format|
      format.js
    end
  end

  # GET /lecturers/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /lecturers
  # POST /lecturers.json
  def create
    @lecturer = Lecturer.new(lecturer_params)
    authorize! :create, @lecturer
    respond_to do |format|
      if @lecturer.save
        flash[:notice] = 'Lecturer was successfully created.'
        format.js
        # format.html { redirect_to @lecturer, notice: 'Lecturer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @lecturer }
      else
        format.js { render action: 'new' }
        # format.html { render action: 'new' }
        format.json { render json: @lecturer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lecturers/1
  # PATCH/PUT /lecturers/1.json
  def update
    respond_to do |format|
      if @lecturer.update(lecturer_params)
        flash[:notice] = 'Lecturer was successfully updated.'
        format.js
        # format.html { redirect_to @lecturer, notice: 'Lecturer was successfully updated.' }
        format.json { head :no_content }
      else
        format.js { render action: 'edit' }
        # format.html { render action: 'edit' }
        format.json { render json: @lecturer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lecturers/1
  # DELETE /lecturers/1.json
  def destroy
    @lecturer.destroy
    respond_to do |format|
      format.html { redirect_to lecturers_url }
      format.json { head :no_content }
    end
  end

  def search
    authorize! :search, Lecturer
    d_id = current_user.userable.department_id
    @lecturers = Lecturer.where{(department_id == d_id)}.search(params[:query])
    respond_to do |format|
      format.json
    end
  end

  def reset_password
    if @lecturer.reset_user
      flash[:notice] = "Reset password berhasil dilakukan"
      render templete: 'reset_password'
    else
      redirect_to authenticated_root, alert: "Something wrong happening here, contact developer"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lecturer
      @lecturer = Lecturer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lecturer_params
      params.require(:lecturer).permit(:nip, :nid, :full_name, :address, :born, :level, :front_title, :back_title, :department_id, :is_admin)
    end
end
