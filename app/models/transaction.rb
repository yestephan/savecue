class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :user_cue
end
