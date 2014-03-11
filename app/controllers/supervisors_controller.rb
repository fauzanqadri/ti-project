class SupervisorsController < ApplicationController
  skip_before_filter :authenticate_user!, only: :index
  before_action :set_supervisor, only: [:destroy, :approve]
  load_and_authorize_resource
  skip_load_resource only: [:new, :create, :waiting_approval, :approve, :become_supervisor]
  # GET /supervisors
  # GET /supervisors.json
  def index
    respond_to do |format|
      format.json {render json: SupervisorsDatatable.new(view_context)}
    end
  end

  # GET /supervisors/new
  def new
    @course = Course.find(course_id)
    @supervisor = @course.supervisors.new
    authorize! :new, @supervisor
    respond_to do |format|
      format.js
    end
    # @supervisor = Supervisor.new
  end

  # POST /supervisors
  # POST /supervisors.json
  def create
    @course = Course.find(course_id)
    @supervisor = @course.supervisors.build(supervisor_params)
    @supervisor.userable = current_user.userable
    respond_to do |format|
      if @supervisor.save
        flash[:notice] = 'Permohonan pengajuan pembimbing berhasil'
        format.js
        format.html { redirect_to @supervisor}
      else
        format.js { render action: 'new' }
        format.html { render action: 'new' }
      end
    end
  end

  # DELETE /supervisors/1
  # DELETE /supervisors/1.json
  def destroy
    @supervisor.destroy
    respond_to do |format|
      format.html { redirect_to @course }
      format.json { head :no_content }
    end
  end

  def become_supervisor
    @course = Course.find(course_id)
    @supervisor = @course.supervisors.build(lecturer_id: current_user.userable_id)
    @supervisor.userable = current_user.userable
    authorize! :become_supervisor, @supervisor
    if @supervisor.save
      redirect_to @course, notice: "Berhasil menjadi pembimbing pada #{@course.class.to_s.downcase} ini"
    else
      msg = @supervisor.errors.full_messages.join(", ")
      redirect_to authenticated_root_path, alert: msg
    end
  end

  def waiting_approval
    authorize! :waiting_approval, Supervisor
    respond_to do |format|
      format.html
      format.json {render json: WaitingApprovalDatatable.new(view_context)}
    end
  end

  def approve
    authorize! :approve, @supervisor
    @supervisor.approved = true
    respond_to do |format|
      if @supervisor.save
        format.html {redirect_to @course, notice: "Berhasil meyetujui pembimbingan skripsi / Pkl"}
      else
        format.html {redirect_to waiting_approval_url, alert: @supervisor.errors.full_messages.join(", ")}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supervisor
      @course = Course.find(course_id)
      @supervisor = @course.supervisors.find(params[:id])
      # @supervisor = Supervisor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supervisor_params
      params.require(:supervisor).permit(:lecturer_id)
    end

    def course_id
      return params[:skripsi_id] if params[:skripsi_id].present?
      params[:pkl_id]
    end
end
