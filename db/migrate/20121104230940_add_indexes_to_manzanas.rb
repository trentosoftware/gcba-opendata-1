class AddIndexesToManzanas < ActiveRecord::Migration
  def change
    add_index :parcelas_data, :manzana
    add_index :manzanas_geometries, :manz
  end
end
