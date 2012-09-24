class AddParcelasGeometryToParcelasData < ActiveRecord::Migration
  def change
    add_column :parcelas_data, :parcelas_geometry_id, :integer
  end
end
