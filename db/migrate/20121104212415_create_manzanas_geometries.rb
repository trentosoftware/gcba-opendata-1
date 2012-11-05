class CreateManzanasGeometries < ActiveRecord::Migration
  def change
    create_table :manzanas_geometries do |t|
      t.integer :gid
      t.string :sec
      t.string :manz
      t.string :sm
      t.string :obs2
      t.string :sourcethm

      t.decimal :area_feet
      t.decimal :perimeter_
      t.decimal :acres
      t.decimal :hectares
      t.decimal :area_feet__9
      t.decimal :perimeter___10
      t.decimal :area_feet__11
      t.decimal :perimeter___12
      t.decimal :area
      t.decimal :perimeter

      t.geometry :geometry, :type => :multipolygon, :srid => 4326
      #9807
    end
  end
end
