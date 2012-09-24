class CreateParcelasGeometries < ActiveRecord::Migration
  def change
    create_table :parcelas_geometries do |t|
      t.string :seccion
      t.string :manzana
      t.string :parcela
      t.string :smp
      t.text :geometry

    end
  end
end
