class Dataset < ActiveRecord::Migration
  def up
    ParcelasData.create :fecha => '2008-06-26', :barrio => 'RECOLETA', :seccion => 'RECOLETA', :manzana => '15', :parcela => '147', :smp => '025', :calle => '15-147-025', :nro => 'GELLY Y OBES, GRAL.', :calle2 => '2284', :chapa_visible => '', :tipo1 => 'SI', :tipo2 => 'GAP', :pisos => 'GARAGE PRIVADO', :nombre => '1



  end

  def down
  end
end