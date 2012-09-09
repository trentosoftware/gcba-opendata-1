class Dataset < ActiveRecord::Migration
  def up
ParcelasData.create :fecha => "2009-04-16", :barrio => "VILLA SANTA RITA", :seccion => "67", :manzana => "036D", :parcela => "020", :smp => "67-036D-020", :calle => "CHIMBORAZO", :nro => "2152", :calle2 => "2154", :chapa_visible => "SI", :tipo1 => "E", :tipo2 => "VIVIENDA", :pisos => "2", :nombre => ""
ParcelasData.create :fecha => "2009-04-16", :barrio => "VILLA SANTA RITA", :seccion => "67", :manzana => "036D", :parcela => "021", :smp => "67-036D-021", :calle => "CHIMBORAZO", :nro => "2162", :calle2 => "2164X", :chapa_visible => "SI", :tipo1 => "E", :tipo2 => "VIVIENDA", :pisos => "2", :nombre => ""
ParcelasData.create :fecha => "2009-04-16", :barrio => "VILLA SANTA RITA", :seccion => "67", :manzana => "036D", :parcela => "022", :smp => "67-036D-022", :calle => "CHIMBORAZO", :nro => "2172", :calle2 => "", :chapa_visible => "SI", :tipo1 => "E", :tipo2 => "CASA", :pisos => "2", :nombre => ""
  end

  def down
  end
end

