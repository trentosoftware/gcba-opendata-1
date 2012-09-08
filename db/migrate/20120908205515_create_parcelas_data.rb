class CreateParcelasData < ActiveRecord::Migration
  def change
    create_table :parcelas_data do |t|
      t.string :fecha
      t.string :barrio
      t.string :seccion
      t.string :manzana
      t.string :parcela
      t.string :smp
      t.string :calle
      t.string :nro
      t.string :calle2
      t.string :chapa_visible
      t.string :tipo1
      t.string :tipo2
      t.string :pisos
      t.string :nombre

      t.timestamps
    end
  end
end
