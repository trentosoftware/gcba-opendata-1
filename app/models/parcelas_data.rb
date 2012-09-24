class ParcelasData < ActiveRecord::Base
  attr_accessible :barrio, :calle, :calle2, :chapa_visible, :fecha, :manzana, :nombre, :nro, :parcela, :pisos, :seccion, :smp, :tipo1, :tipo2, :parcelas_geometries
  belongs_to :parcelas_geometries, :primary_key => 'smp', :foreign_key => 'smp'

end
