class ImportsController < ApplicationController
  before_action :set_import, only: [:download, :destroy, :populate]
  load_and_authorize_resource
  skip_load_resource only: [:create]

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
    head :ok
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
    authorize! :create, @import
    @import.userable = current_user.userable
    respond_to do |format|
      if @import.save
        flash[:notice] = "Record import berhasil dibuat, proses ekstraksi sedang berjalan, mohon tidak menghapus record sampai proses selesai"
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
      flash[:notice] = "Record import berhasil dihapus, #{undo_link(@import)}"
      format.html { redirect_to imports_url }
      format.json { head :no_content }
    end
  end

  def populate
    if @import.populate_imported_file
      flash[:notice] = "Extraksi ulang file record import, mohon tidak menghapus record sampai proses selesai"
      redirect_to imports_url
    else
      flash[:notice] = "Extraksi gagal kontak developer"
      redirect_to imports_url
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
