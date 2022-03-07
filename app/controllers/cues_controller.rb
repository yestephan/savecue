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

    @cues.each do |cue|
      if cue.selected == false
        @cues = Cue.all
     else
        @msg_error = "The cue is already selected ! Please choose another cue!"
     end
    end
  end

  def select!
    @cues = Cue.find_by
    @cue.selected = true
  end
end
