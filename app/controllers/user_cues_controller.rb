class UserCuesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @cue = Cue.find(params[:cue_id])
    @user_cue = current_user.user_cues.find {|user_cue| user_cue.cue == @cue}
    if @user_cue.nil?
      @user_cue = UserCue.new
    end
    if current_user.savings_account.nil? || current_user.checking_account.nil?
      @submit_title = "Next"
    else
      @submit_title = "Confirm"
    end
    unless @user_cue.id.nil?
      render :edit
    end
  end

  def create
    @cue = Cue.find(params[:cue_id])
    @user = current_user
    @user_cue = UserCue.new(usercue_params)
    @user_cue.user = @user
    @user_cue.cue = @cue
    @user_cue.save!

    if current_user.checking_account.nil?
      redirect_to signup_checking_account_path(url_origin: "signup")
    elsif current_user.savings_account.nil?
      redirect_to signup_savings_account_path(url_origin: "signup")
    else
      redirect_to home_path
    end
  end

  def show
    @user_cue = UserCue.find(params[:id])
    @total_saved = 5
  end

  def edit
    @user = current_user
    @user_cue = UserCue.find(params[:id])
  end

  def destroy
    @user = current_user
    @user_cue = UserCue.find(params[:id])
    @user_cue.destroy
    redirect_to home_path
  end

  def update
    @user = current_user
    @user_cue = UserCue.find(params[:id])

    if @user_cue.update(usercue_params)
      redirect_to home_path
    else
      render :edit
    end
  end

  private

  def usercue_params
    params.require(:user_cue).permit(:cue_amount, :meta_data, :url_origin, :location, :latitude, :longitude)
  end
end
