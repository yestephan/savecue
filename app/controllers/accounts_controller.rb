class AccountsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_account_types

  def index
    @checking_account = current_user.checking_account
    @savings_account = current_user.savings_account
  end

  def checking
    origin = params[:url_origin]
    current_account = current_user.checking_account
    unless current_account.nil?
      @page_title = "Edit your checking account"
      @account = current_account
      @account_type = Account::TYPE_CHECKING
      @form_path = account_path(@account)
    else
      @page_title = "From where do we get that money?"
      @account = Account.new
      @account_type = Account::TYPE_CHECKING
      @form_path = accounts_checking_path(url_origin: origin)
    end
    render :form
  end

  def savings
    origin = params[:url_origin]
    current_account = current_user.savings_account
    unless current_account.nil?
      @page_title = "Edit your savings account"
      @account = current_account
      @account_type = Account::TYPE_SAVINGS
      @form_path = account_path(@account)
    else
      @page_title = "Where should the money go?"
      @account = Account.new
      @account_type = Account::TYPE_SAVINGS
      @form_path = accounts_savings_path(url_origin: origin)
    end
    render :form
  end

  def create
    origin = params[:url_origin]
    account_type = params[:account_type]
    @account = Account.new(account_params)
    @account.user = current_user
    if @account.save!
      if origin == "signup" && account_type == Account::TYPE_CHECKING
        redirect_to signup_savings_account_path(url_origin: "signup")
      elsif origin == "signup" && account_type == Account::TYPE_SAVINGS
        redirect_to confirmation_path
      else
        redirect_to accounts_path
      end
    else
      @page_title = params[:account][:page_title]
      @form_path = params[:account][:form_path]
      render :form
    end
  end

  def update
    received_params = account_params
    @account = Account.find(received_params[:id])
    if @account.update(received_params)
      if current_user.accounts.count < 2
        redirect_to "#{root_url}/signup/savings-account?url_origin=signup"
      else
      redirect_to accounts_path
      end
    else
      @page_title = params[:account][:page_title]
      @form_path = params[:account][:form_path]
      render :form
    end
  end

  def destroy
    account = Account.find(params[:id])
    account.destroy
    redirect_to accounts_path
  end

  private
  def account_params
    params.require(:account).permit(:id, :account_type, :name, :iban, :url_origin)
  end
end
