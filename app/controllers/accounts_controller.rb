class AccountsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_account_types

  def index
    @debtor_account = Account.find_by(user_id: current_user, account_type: "debtor")
    @creditor_account = Account.find_by(user_id: current_user, account_type: "creditor")
  end

  def debtor
    origin = params[:url_origin]
    if current_user.accounts.find_by(account_type: "debtor")
      @page_title = "Edit your debit account"
      @account = current_user.accounts.find_by(account_type: "debtor")
      @account_type = "debtor"
      @form_path = account_path(@account)
    else
      @page_title = "From where do we get that money?"
      @account = Account.new
      @account_type = "debtor"
      @form_path = accounts_debtor_path(url_origin: origin)
    end
    render :form
  end

  def creditor
    origin = params[:url_origin]
    if current_user.accounts.find_by(account_type: "creditor")
      @page_title = "Edit your savings account"
      @account = current_user.accounts.find_by(account_type: "creditor")
      @account_type = "creditor"
      @form_path = account_path(@account)
    else
      @page_title = "Where should the money go?"
      @account = Account.new
      @account_type = "creditor"
      @form_path = accounts_creditor_path(url_origin: origin)
    end
    render :form
  end

  def create
    origin = params[:url_origin]
    account_type = params[:account_type]
    @account = Account.new(account_params)
    @account.user = current_user
    if @account.save!
      if origin == "signup" && account_type == "debtor"
        redirect_to signup_creditor_account_path(url_origin: "signup")
      elsif origin == "signup" && account_type == "creditor"
        redirect_to home_path
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
      redirect_to accounts_path
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
