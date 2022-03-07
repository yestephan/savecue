class UserCuesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
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
    render :new
  end

  def update
    @user = current_user
    @user_cue = UserCue.find(params[:id])
    if @user_cue.update(usercue_params)
      redirect_to profile_path
    else
      render :new
    end

    if  @user_cue.cue.title == rainy?
      update_city(meta_data)
    end
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
