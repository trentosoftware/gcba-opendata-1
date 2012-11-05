class ManzanasGeometry < ActiveRecord::Base
  require 'rgeo/geo_json'

  attr_accessible :gid, :sec, :manz, :sm, :obs2, :sourcethm, :area_feet,
                  :perimeter_, :acres, :hectares, :area_feet__9, :perimeter___10,
                  :area_feet__11, :perimeter___12, :area, :perimeter, :geometry

  has_many :parcelas_data, :class_name => 'ParcelasData', :foreign_key => 'manzana', :primary_key => 'manz'


  def as_json(options={})
    included_attrs = [:geometry]
    ret = super(:only => included_attrs)
    ret['geometry'] = RGeo::GeoJSON.encode(ret['geometry'])
    ret['properties'] = {}
    ret['properties']['sm'] = ret[:sm]
    ret.delete(:sm)
    ret['type'] = 'Feature'
    ret
  end


end