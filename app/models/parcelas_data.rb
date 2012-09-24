class ParcelasData < ActiveRecord::Base
<<<<<<< HEAD
  attr_accessible :barrio, :calle, :calle2, :chapa_visible, :fecha, :manzana, :nombre, :nro, :parcela, :pisos,
                  :seccion, :smp, :tipo1, :tipo2, :geometry
=======
  attr_accessible :barrio, :calle, :calle2, :chapa_visible, :fecha, :manzana, :nombre, :nro, :parcela, :pisos, :seccion, :smp, :tipo1, :tipo2
  has_one :parcelas_geometry

>>>>>>> 8e7520dea8650c5de1d9a4f48d1df6522c470779
end
