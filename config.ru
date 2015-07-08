# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
# use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET'],
#                            old_secret: ENV['OLD_COOKIE_SECRET']
use Rack::Health
run Rails.application
