class ProfilesController < ApplicationController
  before_action :authenticate_user!

  helper_method :css_for_category
  helper_method :emoji_for_category

  def home
    # It is 230 fixed it because we don't have transactions yet
    @total_saved = 0
    # List of all user cues from current user to be displayed
    @user_cues = current_user.user_cues
  end

  def css_for_category(category)
    case category
    when "rain"
      "bg-barge"
    when "coffee"
      "bg-coffee"
    when "burger"
      "bg-jade"
    else
      "bg-money"
    end
  end

  def emoji_for_category(category)
    case category
    when "rain"
      "🌧"
    when "coffee"
      "☕️"
    when "sunny"
      "☀️"
    else
      "💰"
    end
  end

  def edit
    @profile = current_user
  end

  def show
  end

  def bank_info
  end

  def confirm
  end

  def update
    received_params = profile_update_params
    unless received_params[:picture].nil?
      unless current_user.picture.nil?
        Cloudinary::Api.delete_resources([current_user.picture])
      end
      uploaded_image = Cloudinary::Uploader.upload(received_params[:picture].tempfile.path)
      received_params[:picture] = uploaded_image["public_id"]
    end

    current_user.update(received_params)
    current_user.save

    redirect_to :home
  end

  private
  def profile_update_params
    params.require(:user).permit(:first_name, :last_name, :picture)
  end
end
