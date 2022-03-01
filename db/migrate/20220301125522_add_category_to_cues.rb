class AddCategoryToCues < ActiveRecord::Migration[6.1]
  def change
    add_column :cues, :category, :string
  end
end
