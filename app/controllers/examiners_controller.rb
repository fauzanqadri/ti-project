class ExaminersController < ApplicationController
  before_action :set_examiner, only: [:show, :edit, :update, :destroy]

  # GET /examiners
  # GET /examiners.json
  def index
    @examiners = Examiner.all
  end

  # GET /examiners/1
  # GET /examiners/1.json
  def show
  end

  # GET /examiners/new
  def new
    @examiner = Examiner.new
  end

  # GET /examiners/1/edit
  def edit
  end

  # POST /examiners
  # POST /examiners.json
  def create
    @examiner = Examiner.new(examiner_params)

    respond_to do |format|
      if @examiner.save
        format.html { redirect_to @examiner, notice: 'Examiner was successfully created.' }
        format.json { render action: 'show', status: :created, location: @examiner }
      else
        format.html { render action: 'new' }
        format.json { render json: @examiner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /examiners/1
  # PATCH/PUT /examiners/1.json
  def update
    respond_to do |format|
      if @examiner.update(examiner_params)
        format.html { redirect_to @examiner, notice: 'Examiner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @examiner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /examiners/1
  # DELETE /examiners/1.json
  def destroy
    @examiner.destroy
    respond_to do |format|
      format.html { redirect_to examiners_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_examiner
      @examiner = Examiner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def examiner_params
      params.require(:examiner).permit(:sidang_id, :lecturer_id)
    end
end
