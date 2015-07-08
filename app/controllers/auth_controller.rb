class AuthController < ApplicationController
  skip_before_action :authenticate, only: %i(signin)

  def signin
    params[:email]
  end

  def signout
  end
end
