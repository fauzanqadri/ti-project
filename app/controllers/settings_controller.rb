class SettingsController < ApplicationController
  # GET /settings
  # GET /settings.json
  def index
    @settings = Setting.all
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:supervisor_skripsi_amount, :supervisor_pkl_amount, :examiner_amount, :maximum_lecturer_lektor_skripsi_lead, :maximum_lecturer_aa_skripsi_lead, :allow_remove_supervisor_duration, :lecturer_lead_skripsi_rule, :lecturer_lead_pkl_rule, :allow_student_create_pkl, :department_id)
    end
end
