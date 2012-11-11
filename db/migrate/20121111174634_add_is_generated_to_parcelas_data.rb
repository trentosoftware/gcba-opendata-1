class AddIsGeneratedToParcelasData < ActiveRecord::Migration
  def change
    def change
      add_column :parcelas_data, :is_generated, :boolean
      ParcelasData.update_all ["is_generated = ?", false]
    end
  end
end
