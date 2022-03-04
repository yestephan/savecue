class CuesController < ApplicationController
  before_action :authenticate_user!
  def index
    @cues = Cue.all
    # If first time then pass this string: "Let's create your first cue"
    @first_time_msg = "Welcome 🎉 Let's setup your first Savecue!"
    @normal_msg = "Welcome 🎉 Let's setup your first Savecue!"
  end
end
