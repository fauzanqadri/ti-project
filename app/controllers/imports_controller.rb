class ImportsController < ApplicationController
  before_action :set_import, only: [:download, :destroy]

  # GET /imports
  # GET /imports.json
  def index
    @imports = Import.all
    respond_to do |format|
      format.html
      format.json { render json: ImportsDatatable.new(view_context)}
    end
  end

  def download
    send_file(@import.package.path, disposition: "attachment", type: @import.package_content_type)
  end

  # GET /imports/new
  def new
    @import = Import.new
    respond_to do |format|
      format.js
    end
  end

  # POST /imports
  # POST /imports.json
  def create
    @import = Import.new(import_params)
    @import.userable = current_user.userable
    respond_to do |format|
      if @import.save
        format.js
        format.json { render action: 'show', status: :created, location: @import }
      else
        format.js { render action: 'new' }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /imports/1
  # DELETE /imports/1.json
  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      params.require(:import).permit(:klass_action, :package, :department_id)
    end
end
