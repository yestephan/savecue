class UserCue < ApplicationRecord
  belongs_to :user
  belongs_to :cue
end
