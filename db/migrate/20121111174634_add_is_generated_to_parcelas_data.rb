class AddIsGeneratedToParcelasData < ActiveRecord::Migration
  def change
    add_column :parcelas_data, :is_generated, :boolean, :default => false
    ParcelasData.update_all ["is_generated = ?", false]
  end
end
