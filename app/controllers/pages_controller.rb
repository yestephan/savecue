class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home, :raise => false
  def home
    @total_saved = 15
  end

  def ui_kit
  end

end
