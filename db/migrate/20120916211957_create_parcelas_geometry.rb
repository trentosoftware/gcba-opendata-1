class CreateParcelasGeometry < ActiveRecord::Migration
  def change
    create_table :parcelas_geometry do |t|
      t.string :seccion
      t.string :manzana
      t.string :parcela
      t.string :smp
      t.text :geometry

    end
  end
end
