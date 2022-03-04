class CuesController < ApplicationController
  before_action :authenticate_user!
  def index
    @cues = Cue.all
    # If first time then pass this string: "Let's create your first cue"
  end
end
