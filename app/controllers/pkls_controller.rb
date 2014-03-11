class PklsController < ApplicationController
  before_action :set_pkl, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate_user!, only: :show
  load_and_authorize_resource
  skip_load_resource only: [:create]
  # GET /pkls/1
  # GET /pkls/1.json
  def show
  end

  # GET /pkls/new
  def new
    @pkl = current_user.userable.pkls.build
    respond_to do |format|
      format.js
    end
  end

  # GET /pkls/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /pkls
  # POST /pkls.json
  def create
    @pkl = current_user.userable.pkls.build(pkl_params)
    authorize! :create, @pkl
    respond_to do |format|
      if @pkl.save
        flash[:notice] = 'Pkl was successfully created.'
        format.js
        format.json { render action: 'show', status: :created, location: @pkl }
      else
        format.js { render action: 'new' }
        format.json { render json: @pkl.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pkls/1
  # PATCH/PUT /pkls/1.json
  def update
    respond_to do |format|
      if @pkl.update(pkl_params)
        flash[:notice] = 'Pkl was successfully updated.'
        format.js
        format.json { head :no_content }
      else
        format.js { render action: 'edit' }
        format.json { render json: @pkl.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pkls/1
  # DELETE /pkls/1.json
  def destroy
    @pkl.destroy
    respond_to do |format|
      format.html { redirect_to authenticated_root_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pkl
      @pkl = Pkl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pkl_params
      params.require(:pkl).permit(:title, :description, :concentration_id, papers_attributes: [:name, :bundle])
    end
end
