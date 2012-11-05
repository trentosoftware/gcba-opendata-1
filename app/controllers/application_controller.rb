class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
  end

  def nearest_manzanas
    category = params[:category]
    cat = params[:category].upcase
    condition = "tipo2 like ?", "%#{cat}%"

    lat = params[:lat].to_f
    long = params[:long].to_f
    search_criteria = params[:category]

    res = ParcelasGeometry.find_by_sql ['select * ' +
                                      'from manzanas_geometries as parm inner join parcelas_data as pard ' +
                                            'on pard.manzana = parm.manz' +
                                      ' where pard.tipo2 like ? or pard.nombre like ? ' +
                                            'order by ST_Transform(parm.geometry, 4326) <-> ST_Point(?,?) ' +
                                            ' limit ?',
                                        "%#{cat}%", "%#{cat}%", long, lat, 100]

    response = add_geo_json_header(res)

    response['features'].each do |elem|
      elem['properties']['parcelas_data'].reject! do |el|
        el['tipo2'].upcase.index(cat).nil? and el['nombre'].upcase.index(cat).nil?
      end
    end

    render :json => response

  end

  def nearest_parcelas
    category = params[:category]
    cat = params[:category].upcase
    condition = "tipo2 like ?", "%#{cat}%"

    lat = params[:lat].to_f
    long = params[:long].to_f
    search_criteria = params[:category]

    res = ParcelasGeometry.find_by_sql ['select * ' +
                                      'from parcelas_geometries as parg inner join parcelas_data as pard ' +
                                            'on pard.smp = parg.smp' +
                                      ' where pard.tipo2 like ? or pard.nombre like ? ' +
                                            'order by ST_Transform(parg.geometry, 4326) <-> ST_Point(?,?) ' +
                                            ' limit ?',
                                        "%#{cat}%", "%#{cat}%", long, lat, 50]

    response = add_geo_json_header(res)

    response['features'].each do |elem|
      elem['properties']['parcelas_data'].reject! do |el|
        el['tipo2'].upcase.index(cat).nil? and el['nombre'].upcase.index(cat).nil?
      end
    end

    render :json => response
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

  def add_geo_json_header2 geometries
    json_response = {}
    json_response['type'] = 'FeatureCollection'
    json_response['features'] = geometries.as_json()
    json_response
  end


end
