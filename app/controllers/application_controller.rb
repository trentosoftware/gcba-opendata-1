class ApplicationController < ActionController::Base
  protect_from_forgery

  def index

  end

  def parcelas_by_seccion
    seccion = params[:seccion]
    resp = ParcelasData.where("seccion = '#{seccion}'")
    render :json => resp.to_json(:include => :parcelas_geometries)
  end
end
