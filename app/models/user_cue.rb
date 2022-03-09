class UserCue < ApplicationRecord
  belongs_to :user
  belongs_to :cue

  attribute :metadata, :jsonb, default: {}

  # getters

  def location
    self.metadata["location"]
  end

  def latitude
    self.metadata["latitude"]
  end

  def longitude
    self.metadata["longitude"]
  end

  # setter
  def location=(value)
    self.metadata["location"] = value
  end

  def latitude=(value)
    self.metadata["latitude"] = value
  end

  def longitude=(value)
    self.metadata["longitude"] = value
  end
end
