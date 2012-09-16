class AddGeometryToParcelasData < ActiveRecord::Migration
  def change
    add_column :parcelas_data, :geometry, :string
  end
end
