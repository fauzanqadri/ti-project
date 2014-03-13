class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy, :reset_password]
  load_and_authorize_resource
  skip_load_resource only: [:create]
  # GET /students
  # GET /students.json
  def index
    @students = Student.all
    respond_to do |format|
      format.html
      format.json {render json: StudentsDatatable.new(view_context)}
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    respond_to do |format|
      format.js
    end
  end

  # GET /students/new
  def new
    @student = Student.new
    respond_to do |format|
      format.js
    end
  end

  # GET /students/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)
    authorize! :create, @student
    respond_to do |format|
      if @student.save
        flash[:notice] = 'Student was successfully created.'
        format.js
        # format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render action: 'show', status: :created, location: @student }
      else
        format.js {render action: 'new'}
        # format.html { render action: 'new' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        flash[:notice] = 'Student was successfully updated.'
        format.js
        # format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.js { render action: 'edit' }
        # format.html { render action: 'edit' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end

  def reset_password
    if @student.reset_user
      flash[:notice] = "Reset password berhasil dilakukan"
      render templete: 'reset_password'
    else
      redirect_to authenticated_root, alert: "Something wrong happening here, contact developer"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:nim, :full_name, :address, :born, :student_since, :department_id, user_attributes: [:email, :username, :password, :password_confirmation], avatar_attributes: [:image])
    end
end
