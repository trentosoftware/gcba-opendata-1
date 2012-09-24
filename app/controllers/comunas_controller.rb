class ComunasController < ActionController::Base
  protect_from_forgery

  def index
  end

  def list
    respond_to do |format|
      format.json { render :partial => "comunas/comunas.mock.json" }
    end
  end

end