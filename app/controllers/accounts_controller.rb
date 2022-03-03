class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account_types

  def index
    @debtor_account = current_user.debtor_account
    @creditor_account = current_user.creditor_account
  end

  def debtor
    @page_title = "Debtor account"
    unless current_user.debtor_account.nil?
      @account = current_user.debtor_account
      @form_path = accounts_path
    else
      @account = Account.new
      @form_path = accounts_debtor_path
    end

    render :form
  end

  def creditor
    @page_title = "Creditor account"
    unless current_user.creditor_account.nil?
      @account = current_user.creditor_account
      @form_path = accounts_path
    else
      @account = Account.new
      @form_path = accounts_creditor_path
    end
    render :form
  end

  def create
    account_type = params[:account_type]

    # create account
    @account = Account.new(account_params)
    if @account.save
      if account_type == "creditor"
        current_user.creditor_account = @account
      elsif
        current_user.debtor_account = @account
      end
      current_user.save
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
    params.require(:account).permit(:id, :name, :account_type, :iban)
  end
end
