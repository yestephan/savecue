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
    @user_cues = current_user.user_cues

    # List transactions
    @access_token = helpers.get_access_token
    @customer_id = helpers.get_customer_id(@access_token)

    checking_account = current_user.checking_account
    unless checking_account.nil?
      @checking_iban = checking_account.iban
    end

    savings_account = current_user.savings_account
    unless savings_account.nil?
      @savings_iban = savings_account.iban
    end

    @account_id = helpers.get_account_id(@access_token, @customer_id, @savings_iban)
    @transactions = get_all_savecue_transactions(@access_token, @customer_id, @account_id)
    # Counting totals
    @total_saved = count_total(@transactions)
    # Counting amount for each cues
    @total_each_cue_saved = count_total_for_each_cue(@transactions)
    @total_amount_cue = @total_each_cue_saved[@user_cue.name.to_s]
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
      if current_user.accounts.count < 2
        redirect_to "#{root_url}/signup/checking-account?url_origin=signup"
      else
      redirect_to home_path
      end
    else
      render :edit
    end
  end

  private

  def usercue_params
    params.require(:user_cue).permit(:cue_amount, :meta_data, :url_origin, :location, :latitude, :longitude)
  end
end
