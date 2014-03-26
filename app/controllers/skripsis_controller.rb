class SkripsisController < ApplicationController
  skip_before_filter :authenticate_user!, only: :show
  skip_before_filter :checking_setting!, only: :show
  skip_before_filter :checking_assessment!, only: :show
  before_action :set_skripsi, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  skip_load_resource only: [:create]
  # GET /skripsis/1
  # GET /skripsis/1.json
  def show
  end

  # GET /skripsis/new
  def new
    @skripsi = current_user.userable.skripsis.build
    respond_to do |format|
      format.js
    end
  end

  # GET /skripsis/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /skripsis
  # POST /skripsis.json
  def create
    @skripsi = current_user.userable.skripsis.build(skripsi_params)
    authorize! :create, @skripsi
    respond_to do |format|
      if @skripsi.save
        flash[:notice] = "Record skripsi berhasil dibuat, #{undo_link(@skripsi)}"
        format.js
        format.json { render action: 'show', status: :created, location: @skripsi }
      else
        format.js {render action: 'new'}
        format.json { render json: @skripsi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skripsis/1
  # PATCH/PUT /skripsis/1.json
  def update
    respond_to do |format|
      if @skripsi.update(skripsi_params)
        flash[:notice] = "Record skripsi berhasil diubah, #{undo_link(@skripsi)}"
        format.js
        format.json { head :no_content }
      else
        format.js { render action: 'edit' }
        format.json { render json: @skripsi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skripsis/1
  # DELETE /skripsis/1.json
  def destroy
    @skripsi.destroy
    respond_to do |format|
      flash[:notice] = "Record skripsi berhasil dihapus, #{undo_link(@skripsi)}"
      format.html { redirect_to authenticated_root_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skripsi
      @skripsi = Skripsi.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def skripsi_params
      params.require(:skripsi).permit(:title, :description, :concentration_id, papers_attributes: [:name, :bundle])
    end
end
