class CuesController < ApplicationController
  before_action :authenticate_user!
  def index
    @cues = Cue.all
  end
end
