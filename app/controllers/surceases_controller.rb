class SurceasesController < ApplicationController
  load_and_authorize_resource

  # GET /surceases
  # GET /surceases.json
  def index
    # @surceases = Surcease.all
    respond_to do |format|
      format.html
      format.json {render json: SurceasesDatatable.new(view_context)}
    end
  end

  def approve
    @surcease = Surcease.find(params[:id])
    respond_to do |format|
      if @surcease.approve
        flash[:notice] = "Berhasil mem-publish, #{undo_link(@surcease)}"
        format.js
      else
        flash[:alert] = "Ada kesalahan kontak ketua prodi"
        format.js
      end
    end
    
  end

  def disapprove
    @surcease = Surcease.find(params[:id])
    respond_to do |format|
      if @surcease.disapprove
        flash[:notice] = "Publish dihentikan, #{undo_link(@surcease)}"
        format.js
      else
        flash[:alert] = "Ada kesalahan kontak ketua prodi"
        format.js
      end
    end
    
  end

end
