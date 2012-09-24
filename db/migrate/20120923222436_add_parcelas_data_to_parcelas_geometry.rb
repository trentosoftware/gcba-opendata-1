class AddParcelasDataToParcelasGeometry < ActiveRecord::Migration
  def change
    add_column :parcelas_geometry, :parcelas_data_id, :integer, :null => true
  end
end
