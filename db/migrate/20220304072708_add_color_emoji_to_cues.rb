class AddColorEmojiToCues < ActiveRecord::Migration[6.1]
  def change
    add_column :cues, :color, :string
    add_column :cues, :emoji, :string
  end
end
