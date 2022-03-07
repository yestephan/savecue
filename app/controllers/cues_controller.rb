class CuesController < ApplicationController
  before_action :authenticate_user!
  helper_method :select

  def index
    origin = params[:url_origin]
    @cues = Cue.all
    # If first time then pass this string: "Let's create your first cue"
    if origin == "signup"
      @back = root_path
      @msg = "Welcome 🎉\nLet's setup your first Savecue!"
    elsif origin == "home"
      @back = home_path
      @msg = "Choose a cue"
    end
  end
end
