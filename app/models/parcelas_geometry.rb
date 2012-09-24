class ParcelasGeometry < ActiveRecord::Base
  attr_accessible :manzana, :parcela, :seccion, :smp, :geometry, :parcelas_data

  has_many :parcelas_data, :class_name => 'ParcelasData', :foreign_key => 'smp', :primary_key => 'smp'

  def as_json(options={})
    included_attrs = [:geometry]
    ret = super(:only => included_attrs, :include => :parcelas_data)
    ret['geometry'] = JSON.parse(ret['geometry'])
    ret['properties'] = {}
    puts ret
    ret['properties']['parcelas_data'] = ret[:parcelas_data]
    ret.delete(:parcelas_data)
    ret['type'] = 'Feature'
    ret
  end

end