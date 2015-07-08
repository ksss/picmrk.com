class AccountController < ApplicationController
  skip_before_action :authenticate, only: %i(create)
  before_action :filter_account, only: %i(create update)

  def edit
  end

  def update
    if current_account.update(account_params)
      redirect_to :edit_account, notice: 'updated'
    else
      redirect_to :edit_account, alert: 'update failed'
    end
  end

  def create
    sign = Sign.find_by(token: params[:token])
    redirect_to root_path, alert: 'unauthorilze' and return unless sign

    unless sign.deauthorize
      redirect_to root_path, alert: sign.errors.full_messages.join(',') and return
    end

    account = Account.new(account_params)
    unless account.save
      redirect_to root_path, alert: account.errors.full_messages.join(',') and return
    end

    session[:account_id] = account.id
    redirect_to streams_path and return
  end

  private

    def filter_account
      if Account.system_name?(account_params[:name])
        @account = Account.new(account_params)
        flash.now[:alert] = "cannot using name"
        render :edit and return
      end
    end

    def account_params
      params.require(:account).permit(:name, :email, :icon_url)
    end
end
