class AddMetadataToUserCues < ActiveRecord::Migration[6.1]
  def change
    add_column :user_cues, :metadata, :jsonb
  end
end
