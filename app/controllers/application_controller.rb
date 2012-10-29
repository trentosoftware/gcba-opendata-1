class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
  end

  def nearest_parcelas
    lat = params[:lat].to_f
    long = params[:long].to_f
    search_criteria = params[:category]
    #ST_AsGeoJSON(ST_Transform(geometry,4326)) as geometry, smp
    res = ParcelasGeometry.find_by_sql ['select * ' +
                                      'from parcelas_geometries' +
                                      ' order by ST_Transform(geometry, 4326) <-> ST_Point(?,?) limit ?',
                                  long, lat, 500]

    #response = res.to_a.map! do |e|
    #  e
    #end
    #while row = results.fetch_row do
    #   puts row
    #end
    render :json => res.to_a
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
