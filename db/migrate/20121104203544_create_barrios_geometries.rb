class CreateBarriosGeometries < ActiveRecord::Migration
  def change
    create_table :barrios_geometries do |t|
      t.integer :gid
      t.string :barrio
      t.decimal :perimetro
      t.decimal :area
      t.integer :comuna
      t.geometry :geometry, :type => :multipolygon, :srid => 4326
      #9807
    end
  end

end
