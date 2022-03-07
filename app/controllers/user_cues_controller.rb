class UserCuesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  helper_method :info_for_category

  def new
    @user_cue = UserCue.new
    @cue = Cue.find(params[:cue_id])
  end

  def create
    @cue = Cue.find(params[:cue_id])
    @user = current_user
    @user_cue = UserCue.new(usercue_params)
    @user_cue.user = @user
    @user_cue.cue = @cue
    @user_cue.save!

    if current_user.accounts.find_by(account_type: "checking")
      redirect_to home_path
    else
      redirect_to signup_checking_account_path(url_origin: "signup")
    end
  end

  def show
    @user_cue = UserCue.find_by(id: params[:id])
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
      "how much do you save for each rainy day"
    when "coffee"
      "how much do you save for each coffee break"
    when "sunny"
      "how much do you save for each sunny day"
    else
      "how much do you save for each big spenda"
    end
  end
  private

  def usercue_params
    params.require(:user_cue).permit(:cue_amount, :meta_data, :url_origin)
  end
end
