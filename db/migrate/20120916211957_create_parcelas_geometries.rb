class CreateParcelasGeometries < ActiveRecord::Migration
  def change
    create_table :parcelas_geometries do |t|
      t.string :seccion
      t.string :manzana
      t.string :parcela
      t.string :obs
      t.string :weblink
      t.string :parc_esq
      t.string :rot_par
      t.string :rot_sec
      t.string :sm
      t.string :partida
      t.string :smp
      t.geometry :geometry, :type => :multi_polygon, :srid => 9807
    end
  end
end