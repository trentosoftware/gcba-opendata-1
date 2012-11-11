class AddAliasesToParcelasData < ActiveRecord::Migration
  def change
    add_column :parcelas_data, :aliases, :string
    add_index :parcelas_data, :aliases
  end
end