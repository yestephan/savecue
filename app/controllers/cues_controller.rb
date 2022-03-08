class CuesController < ApplicationController
  before_action :authenticate_user!
  helper_method :select

  def index
    origin = params[:url_origin]

    # loads only cues not used by the user
    user_cues = current_user.user_cues.map { |user_cue| user_cue.cue.id }
    @cues = Cue.where.not(id: user_cues)

    # If first time then pass this string: "Let's create your first cue"
    if origin == "signup"
      @back = root_path
      @msg = "Welcome 🎉\nLet's set up your first Savecue!"
    elsif origin == "home"
      @back = home_path
      @msg = "Choose a cue"
    end
  end
end
