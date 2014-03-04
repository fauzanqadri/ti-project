class ExaminersController < ApplicationController
  before_action :set_examiner, only: :destroy

  # DELETE /examiners/1
  # DELETE /examiners/1.json
  def destroy
    @examiner.destroy
    respond_to do |format|
      format.html { redirect_to conferences_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_examiner
      @skripsi = Skripsi.find(params[:skripsi_id])
      @sidang = @skripsi.sidang
      @examiner = @sidang.examiners.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def examiner_params
      params.require(:examiner).permit(:sidang_id, :lecturer_id)
    end
end
