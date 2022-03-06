class CuesController < ApplicationController
  before_action :authenticate_user!

  def index
    origin = params[:url_origin]
    @cues = Cue.all
    # If first time then pass this string: "Let's create your first cue"
    if origin == "signup"
      @msg = "Welcome 🎉\nLet's setup your first Savecue!"
    else
      @msg = "Choose a cue"
    end
  end
end
