class ConferencesController < ApplicationController
  before_action :set_conference, only: [:show, :edit, :update, :destroy]

  # GET /conferences
  # GET /conferences.json
  def index
    respond_to do |format|
      format.html
      format.json do 
        if params[:skripsi_id].present?
          render json: SkripsiConferencesDatatable.new(view_context)
        else
          if current_user.userable_type == "Lecturer" && current_user.userable.is_admin?
            render json: DepartmentDirectorConferencesDatatable.new(view_context)
          elsif current_user.userable_type == "Staff"
          else
            raise CanCan::AccessDenied.new
          end
        end
      end
    end
  end


  # GET /conferences/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /conferences/1
  # PATCH/PUT /conferences/1.json
  def update
    respond_to do |format|
      if @conference.update(conference_params)
        flash[:notice] = "Berhasil menyetujui #{@conference.type.downcase}"
        format.js
        # format.html { redirect_to @conference, notice: 'Conference was successfully updated.' }
        format.json { head :no_content }
      else
        format.js { render action: 'edit' }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conferences/1
  # DELETE /conferences/1.json
  def destroy
    @conference.destroy
    respond_to do |format|
      format.html { redirect_to conferences_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conference
      @conference = Conference.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conference_params
      if params[:sidang].present?
        return params.require(:sidang).permit(:local, :start, :end, examiners_attributes: [:id, :lecturer_id])
      end
      return params.require(:seminar).permit(:local, :start, :end)
    end
end
