class ConcentrationsController < ApplicationController
  before_action :set_concentration, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  skip_load_resource only: [:create]

  # GET /concentrations
  # GET /concentrations.json
  def index
    respond_to do |format|
      format.html
      format.json {render json: ConcentrationsDatatable.new(view_context)}
    end
    # @concentrations = Concentration.all
  end

  # GET /concentrations/1
  # GET /concentrations/1.json
  def show
  end

  # GET /concentrations/new
  def new
    @concentration = Concentration.new
    respond_to do |format|
      format.js
    end
  end

  # GET /concentrations/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /concentrations
  # POST /concentrations.json
  def create
    @concentration = Concentration.new(concentration_params)
    authorize! :create, @concentration
    respond_to do |format|
      if @concentration.save
        flash[:notice] = "Record konsentrasi berhasil dibuat, #{undo_link(@concentration)}"
        format.json { render action: 'show', status: :created, location: @concentration }
        format.js
      else
        format.json { render json: @concentration.errors, status: :unprocessable_entity }
        format.js {render action: 'new'}
      end
    end
  end

  # PATCH/PUT /concentrations/1
  # PATCH/PUT /concentrations/1.json
  def update
    respond_to do |format|
      if @concentration.update(concentration_params)
        flash[:notice] = "Record konsentrasi berhasil diubah, #{undo_link(@concentration)}"
        format.js
        # format.html { redirect_to @concentration, notice: 'Concentration was successfully updated.' }
        format.json { head :no_content }
      else
        format.js { render action: 'edit' }
        # format.html { render action: 'edit' }
        format.json { render json: @concentration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /concentrations/1
  # DELETE /concentrations/1.json
  def destroy
    @concentration.destroy
    respond_to do |format|
      flash[:notice] = "Record konsentrasi berhasil dihapus, #{undo_link(@concentration)}"
      format.html { redirect_to concentrations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_concentration
      @concentration = Concentration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concentration_params
      params.require(:concentration).permit(:name, :department_id)
    end
end
