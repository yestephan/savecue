class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home, :raise => false
  def home
  end

  def ui_kit
  end

  def confirm
    @user = current_user

  end
end
