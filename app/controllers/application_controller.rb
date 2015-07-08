class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method %i(current_account current_account? signed_in? following?)
  before_action :authenticate
#  rescue_from Exception, with: :error500
#  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :error404

  def error404(e = nil)
    render 'error404', status: 404, formats: [:html]
  end

  def error500(e = nil)
    logger.error [e, *e.backtrace].join("\n")
    render 'error500', status: 500, formats: [:html]
  end

  private

  def current_account
    return unless session[:account_id]
    @current_account ||= Account.find(session[:account_id])
  end

  def current_account?(account)
    current_account == account
  end

  def set_current_account(account)
    session[:account_id] = account.id
    @current_account = account
  end

  def signed_in?
    session.has_key?(:account_id)
  end

  def authenticate
    return if signed_in?
    redirect_to root_path, alert: 'please signin'
  end
end
