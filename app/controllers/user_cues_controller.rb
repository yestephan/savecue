class UserCuesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
  end

  def new
    @user_cue = UserCue.new
  end

  def create
    @user = current_user
    @user_cue = UserCue.new(usercue_params)
    @user_cue.user = @user
    @user_cue.save!
    redirect_to user_cue_path(@user_cue)
    # else
    #   render :new
    # end
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

  private

  def usercue_params
    params.require(:user_cue).permit(:cue_amount, :meta_data)
  end
end
