class SignMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.session_mailer.signin.subject
  #
  def signin(to:)
    @token = start_token(to)
    mail to: to, subject: "picmrk.com signin"
  end

  private

  def start_token(email)
    if sign = Sign.find_by(email: email)
      sign.start.token
    else
      Sign.start(email).token
    end
  end
end
