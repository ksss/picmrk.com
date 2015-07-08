class SignController < ApplicationController
  skip_before_action :authenticate, only: %i(send_email in up)

  def send_email
    fork { SignMailer.signin(to: sign_params[:email]).deliver_now }
    message = "#{sign_params[:email]} 宛にサインインの案内を送りました。"
    redirect_to root_path, notice: message and return
  end

  def in
    sign = Sign.find_by(token: params[:token])

    redirect_to root_path, alert: '有効でないサインインURLです' and return unless sign
    redirect_to root_path, alert: "期限切れのURLです" and return if sign.expired?

    account = Account.find_by(email: sign.email)
    redirect_to signup_path(sign.token) and return unless account

    sign.deauthorize
    session[:account_id] = account.id
    redirect_to streams_path, notice: 'Signed In' and return
  end

  def out
    session[:account_id] = nil
    redirect_to root_path, notice: 'Signed Out' and return
  end

  def up
    redirect_to root_path, alert: 'unauthorilze' and return unless params[:token]

    sign = Sign.find_by(token: params[:token])
    if sign
      @token = sign.token
      @account = Account.new(email: sign.email)
    else
      redirect_to root_path, alert: 'unauthorilze' and return
    end
  end

  private

  def sign_params
    params.require(:sign).permit(:email)
  end
end
