class ParcelasGeometry < ActiveRecord::Base
  attr_accessible :manzana, :parcela, :seccion, :smp, :geometry, :parcelas_data

  belongs_to :parcelas_data, :foreign_key => 'pgm'
end