class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home, :raise => false
  def home
  redirect_to new_user_registration_path if user_signed_in? && current_user.accounts.count < 2


  end

  def ui_kit
  end

  def confirm
    @user = current_user

  end
end
