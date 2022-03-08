class RemoveColorFromCue < ActiveRecord::Migration[6.1]
  def change
    remove_column :cues, :color
    remove_column :cues, :emoji
  end
end
