class AddIndexesToParcelasGeometriesAndParcelasData < ActiveRecord::Migration
  def change
    add_index :parcelas_data, :smp
    #add_index :parcelas_geometries, :smp, :unique => true
  end
end
