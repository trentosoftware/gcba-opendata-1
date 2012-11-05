class BarriosGeometry < ActiveRecord::Base
  require 'rgeo/geo_json'

  attr_accessible :gid, :barrio, :perimetro, :area, :comuna, :geometry

  def as_json(options={})
    included_attrs = [:geometry]
    ret = super(:only => included_attrs)
    ret['geometry'] = RGeo::GeoJSON.encode(ret['geometry'])
    ret['properties'] = {}
    ret['properties']['barrio'] = ret[:barrio]
    ret.delete(:barrio)
    ret['type'] = 'Feature'
    ret
  end


end