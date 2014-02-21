class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  skip_load_resource only: [:create]
  # GET /departments
  # GET /departments.json
  def index
    # @departments = Department.all
    respond_to do |format|
      format.html
      format.json {render json: DepartmentsDatatable.new(view_context)}
    end
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = current_user.userable.faculty.departments.build
    respond_to do |format|
      format.js
    end
  end

  # GET /departments/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = current_user.userable.faculty.departments.build(department_params)
    # authorize! :create, @department
    respond_to do |format|
      if @department.save
        flash[:notice] = 'Department was successfully created.'
        format.json { render action: 'show', status: :created, location: @department }
        format.js
      else
        format.json { render json: @department.errors, status: :unprocessable_entity }
        format.js {render action: 'new'}
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        flash[:notice] = 'Department was successfully updated.'
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @department.errors, status: :unprocessable_entity }
        format.js {render action: 'edit'}
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:name, :website)
    end
end
