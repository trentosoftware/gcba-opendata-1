class ParcelasGeometry < ActiveRecord::Base
  attr_accessible :manzana, :parcela, :seccion, :smp, :geometry, :parcelas_data

  has_many :parcelas_data, :class_name => 'ParcelasData', :foreign_key => 'smp', :primary_key => 'smp'
end