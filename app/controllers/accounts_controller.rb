class AccountsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_account_types

  def index
    @debtor_account = Account.find_by(user_id: current_user, account_type: "debtor")
    @creditor_account = Account.find_by(user_id: current_user, account_type: "creditor")
  end

  def debtor
    if current_user.accounts.find_by(account_type: "debtor")
      @page_title = "Edit your debit account"
      @account = current_user.accounts.find_by(account_type: "debtor")
      @account_type = "debtor"
      @form_path = accounts_path
    else
      @page_title = "From where do we get that money?"
      @account = Account.new
      @account_type = "debtor"
      @form_path = accounts_debtor_path
    end
    render :form
  end

  def creditor
    if current_user.accounts.find_by(account_type: "creditor")
      @page_title = "Edit your savings account"
      @account = current_user.accounts.find_by(account_type: "creditor")
      @account_type = "creditor"
      @form_path = accounts_path
    else
      @page_title = "Where should the money go?"
      @account = Account.new
      @account_type = "creditor"
      @form_path = accounts_creditor_path
    end
    render :form
  end

  def create
    @account = Account.new(account_params)
    @account.user = current_user
    if @account.save!
      redirect_to accounts_path
    else
      @page_title = params[:account][:page_title]
      @form_path = params[:account][:form_path]
      render :form
    end
  end

  def update
    received_params = account_params
    @account = Account.find(received_params[:id])
    if @account.update received_params
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
  def set_account_types
    @account_types = [["Savings", "savings"], ["Checking", "checking"]]
  end

  def account_params
    params.require(:account).permit(:id, :account_type, :name, :iban)
  end
end
