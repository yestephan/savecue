class UserCuesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  helper_method :info_for_category

  def new
    @user_cue = UserCue.new
    @cue = Cue.find(params[:cue_id])
    if current_user.savings_account.nil? || current_user.checking_account.nil?
      @submit_title = "Next"
    else
      @submit_title = "Confirm"
    end
  end

  def create
    @cue = Cue.find(params[:cue_id])
    @user = current_user
    @user_cue = UserCue.new(usercue_params)
    @user_cue.user = @user
    @user_cue.cue = @cue

    if @cue.category == "rain" && !params[:user_cue][:metadata].nil?
      @user_cue.metadata = {"location":params[:user_cue][:metadata]}
    end

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
    unless @user_cue.metadata.nil? || @user_cue.metadata["location"].nil?
      @user_cue.metadata = @user_cue.metadata["location"]
    end
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

    if @user_cue.cue.category == "rain" && !params[:user_cue][:metadata].nil?
      @user_cue.metadata = {"location":params[:user_cue][:metadata]}
    end

    if @user_cue.update(usercue_params)
      redirect_to home_path
    else
      render :edit
    end

    # update_city(meta_data) if @user_cue.cue.title == "rainy"?
  end

  def update_city(meta_data)
    meta_data
  end

  def info_for_category(category)
    case category
    when "rain"

      "How much do you save for each rainy day?"
    when "coffee"
      "How much do you save for each coffee break?"
    when "sunny"
      "How much do you save for each sunny day?"
    else
      "How much do you save for each big spenda?"
    end
  end

  private

  def usercue_params
    params.require(:user_cue).permit(:cue_amount, :meta_data, :url_origin)
  end
end
