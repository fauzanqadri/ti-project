class SettingsController < ApplicationController
  before_action :set_department
  load_and_authorize_resource
  # GET /settings
  # GET /settings.json
  def show
    @setting = @department.setting
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    @department = current_user.userable.department
    @setting = @department.setting
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to settings_url, notice: 'Konfigurasi Berhasil diperbarui' }
        # format.json { head :no_content }
      else
        format.html { render action: 'show' }
        # format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_department
      @department = current_user.userable.department
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:supervisor_skripsi_amount, :supervisor_pkl_amount, :examiner_amount, :maximum_lecturer_lektor_skripsi_lead, :maximum_lecturer_aa_skripsi_lead, :allow_remove_supervisor_duration, :lecturer_lead_skripsi_rule, :lecturer_lead_pkl_rule, :allow_student_create_pkl, :maximum_lecturer_lektor_pkl_lead, :maximum_lecturer_aa_pkl_lead, :department_director, :department_secretary)
    end
end
