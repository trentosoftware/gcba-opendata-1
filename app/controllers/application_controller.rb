class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
  end

  def parcelas_by_seccion
    seccion = params[:seccion]
    geometries = ParcelasGeometry.where("seccion = '#{seccion}'").limit(100)
    render :json => add_geo_json_header(geometries)
  end

  def parcelas_by_category
    category = params[:category]
    cat = params[:category].upcase
    condition = "tipo2 like ?", "%#{cat}%"

    geometries = ParcelasGeometry.includes(:parcelas_data).where("parcelas_data.tipo2 like ? or nombre like ?", "%#{cat}%", "%#{cat}%")

    response = add_geo_json_header(geometries)

    response['features'].each do |elem|
      elem['properties']['parcelas_data'].reject! do |el|
        el['tipo2'].index(cat).nil?
      end
    end


    puts response
    #geometries = ParcelasGeometry.joins(:parcelas_data).where(condition).limit(1000)
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
