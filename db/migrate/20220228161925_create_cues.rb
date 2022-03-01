class CreateCues < ActiveRecord::Migration[6.1]
  def change
    create_table :cues do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
