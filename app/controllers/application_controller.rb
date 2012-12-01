class ApplicationController < ActionController::Base
  require 'extended_string'

  protect_from_forgery

  def coord_transform(long, lat)

    query = ActiveRecord::Base.send(:sanitize_sql_array, ["select ST_X(ST_Transform(ST_SetSRID(ST_Point(?, ?),9807),4326)), ST_Y(ST_Transform(ST_SetSRID(ST_Point(?, ?),9807),4326))", "#{long}", "#{lat}", "#{long}", "#{lat}"])
    results = ActiveRecord::Base.connection.execute(query)

    coords = results.to_a.first
  end

  def index
    lat = BigDecimal.new(params[:lat])
    long = BigDecimal.new(params[:long])
    @cat = params[:cat]
    @dir = params[:direction]

    coords = coord_transform(long, lat)
    @long = coords['st_x']
    @lat = coords['st_y']
    @xpoint = params[:long]
    @ypoint = params[:lat]

  end

  def landing
    render :layout => 'landing'
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

    if (params[:conv].eql?('true'))
      coords = coord_transform(BigDecimal.new(params[:long]), BigDecimal.new(params[:lat]))
      long = coords['st_x']
      lat = coords['st_y']
    else
      long = params[:long].to_f
      lat = params[:lat].to_f
    end

    if params[:category].nil? or params[:category].empty?
      where_clause = []
    else
      cat = params[:category].to_pg_escaped_str.removeaccents
      where_clause = ["unaccent_string(parcelas_data.tipo2) ilike ? or unaccent_string(parcelas_data.nombre) ilike ?", "%#{cat}%", "%#{cat}%"]
    end

    res = ParcelasGeometry.includes(:parcelas_data).where(where_clause).order(
        "ST_Transform(parcelas_geometries.geometry, 4326) <-> ST_Point(#{long},#{lat})").limit(limit)

    response = add_geo_json_header(res)

    render :json => { :lat=>lat, :long=>long, :geojson => response}
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

end
