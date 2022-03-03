class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def home
  end

  def new
  end

  def create
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
