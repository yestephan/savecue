class CreateUserCues < ActiveRecord::Migration[6.1]
  def change
    create_table :user_cues do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cue, null: false, foreign_key: true
      t.float :cue_amount

      t.timestamps
    end
  end
end
