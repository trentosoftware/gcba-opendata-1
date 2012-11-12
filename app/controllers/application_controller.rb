class ApplicationController < ActionController::Base
  require 'extended_string'

  protect_from_forgery

  def index
  end

  def nearest_manzanas
    category = params[:category]
    cat = params[:category].upcase
    limit = params[:limit].to_i

    raise 'search category must have at least 3 characters' if cat.size < 3
    raise 'search limit must be under 200' if limit > 200

    condition = "tipo2 like ?", "%#{cat}%"

    lat = params[:lat].to_f
    long = params[:long].to_f
    search_criteria = params[:category]

    #ManzanasGeometry.find()

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

  def parcelas_by_tag
    limit = params[:limit].to_i > 300 ? 300 : params[:limit].to_i
    lat = params[:lat].to_f
    long = params[:long].to_f

    if params[:tag].nil? or params[:tag].empty?
      where_clause = []
    else
      cat = params[:tag].to_pg_escaped_str.removeaccents
      where_clause = ["parcelas_data.aliases ilike ?", "%#{cat}%"]
    end

    res = ParcelasGeometry.includes(:parcelas_data).where(where_clause).order(
        "ST_Transform(parcelas_geometries.geometry, 4326) <-> ST_Point(#{long},#{lat})").limit(limit)

    response = add_geo_json_header(res)

    render :json => response
  end

  def nearest_parcelas
    limit = params[:limit].to_i > 200 ? 200 : params[:limit].to_i
    lat = params[:lat].to_f
    long = params[:long].to_f

    if params[:category].nil? or params[:category].empty?
      where_clause = []
    else
      cat = params[:category].to_pg_escaped_str.removeaccents
      where_clause = ["unaccent_string(parcelas_data.tipo2) ilike ? or unaccent_string(parcelas_data.nombre) ilike ?", "%#{cat}%", "%#{cat}%"]
    end

    res = ParcelasGeometry.includes(:parcelas_data).where(where_clause).order(
        "ST_Transform(parcelas_geometries.geometry, 4326) <-> ST_Point(#{long},#{lat})").limit(limit)

    response = add_geo_json_header(res)

    render :json => response
  end

  def autocomplete_category
    cat = params[:text].to_pg_escaped_str.removeaccents.upcase

    query = ActiveRecord::Base.send(:sanitize_sql_array, ["select * from autocomplete_search where text like ? order by results desc limit ?", "%#{cat}%", 10])
    results = ActiveRecord::Base.connection.execute(query)
    plucked = results.map do |e|
      e['original_text']
    end

    render :json => { 'autocomplete' => plucked }
  end

  def parcelas_by_seccion
    seccion = params[:seccion]
    geometries = ParcelasGeometry.where("seccion = '#{seccion}'").limit(100)
    render :json => add_geo_json_header(geometries)
  end

  def parcelas_by_category
    cat = params[:category].upcase
    limit = params[:limit].to_i

    condition = "tipo2 like ?", "%#{cat}%"

    raise 'search category must have at least 3 characters' if cat.size < 3
    raise 'search limit must be under 200' if limit > 200

    geometries = ParcelasGeometry.includes(:parcelas_data).where("parcelas_data.tipo2 like ? or nombre like ?", "%#{cat}%", "%#{cat}%").limit(limit)

    response = add_geo_json_header(geometries)

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
