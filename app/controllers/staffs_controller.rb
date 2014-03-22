class StaffsController < ApplicationController
  before_action :set_staff, only: [:show, :edit, :update, :destroy, :reset_password]
  load_and_authorize_resource
  skip_load_resource only: [:create]
  # GET /staffs
  # GET /staffs.json
  def index
    respond_to do |format|
      format.html
      format.json {render json: StaffsDatatable.new(view_context)}
    end
    # @staffs = Staff.all
  end

  # GET /staffs/1
  # GET /staffs/1.json
  def show
    respond_to do |format|
      format.js
    end
  end

  # GET /staffs/new
  def new
    @staff = Staff.new
    respond_to do |format|
      format.js
    end
  end

  # GET /staffs/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /staffs
  # POST /staffs.json
  def create
    @staff = Staff.new(staff_params)
    authorize! :create, @staff
    respond_to do |format|
      if @staff.save
        flash[:notice] = 'Staff was successfully created.'
        format.js
        format.json { render action: 'show', status: :created, location: @staff }
      else
        format.js { render action: 'new' }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staffs/1
  # PATCH/PUT /staffs/1.json
  def update
    respond_to do |format|
      if @staff.update(staff_params)
        flash[:notice] = 'Staff was successfully updated.'
        format.js
        format.json { head :no_content }
      else
        format.js { render action: 'edit' }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staffs/1
  # DELETE /staffs/1.json
  def destroy
    @staff.destroy
    respond_to do |format|
      format.html { redirect_to staffs_url }
      format.json { head :no_content }
    end
  end

  def reset_password
    if @staff.reset_password
      flash[:notice] = "Reset password berhasil dilakukan"
      render templete: 'reset_password'
    else
      redirect_to authenticated_root, alert: "Something wrong happening here, contact developer"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff
      @staff = Staff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_params
      params.require(:staff).permit(:full_name, :address, :born, :staff_since, :faculty_id, user_attributes: [:email, :username, :password, :password_confirmation])
    end
end
