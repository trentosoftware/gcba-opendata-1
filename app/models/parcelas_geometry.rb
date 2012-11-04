class ParcelasGeometry < ActiveRecord::Base
  require 'rgeo/geo_json'

  attr_accessible :manzana, :parcela, :seccion, :smp, :geometry, :parcelas_data

  has_many :parcelas_data, :class_name => 'ParcelasData', :foreign_key => 'smp', :primary_key => 'smp'

  def as_json(options={})
    included_attrs = [:geometry]
    ret = super(:only => included_attrs, :include => :parcelas_data)
    ret['geometry'] = RGeo::GeoJSON.encode(ret['geometry'])
    ret['properties'] = {}
    ret['properties']['parcelas_data'] = ret[:parcelas_data]
    ret.delete(:parcelas_data)
    ret['type'] = 'Feature'
    ret
  end

end