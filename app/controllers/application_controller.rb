class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
  end

  def parcelas_by_seccion
    seccion = params[:seccion]
    geometries = ParcelasGeometry.where("seccion = '#{seccion}'")
    render :json => add_geo_json_header(geometries)
  end

  private

  def add_geo_json_header geometries
    json_response = {}
    json_response['type'] = 'FeatureCollection'
    json_response['features'] = geometries.as_json(:include => :parcelas_data)
    json_response
  end
end
