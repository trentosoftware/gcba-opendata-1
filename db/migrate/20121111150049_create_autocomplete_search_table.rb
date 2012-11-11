class CreateAutocompleteSearchTable < ActiveRecord::Migration
  def change
    create_table :autocomplete_search do |t|
      t.integer :results
      t.string :text
    end

    add_index :autocomplete_search, :results
    add_index :autocomplete_search, :text

  end

end
