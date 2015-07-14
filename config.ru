# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
# use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET'],
#                            old_secret: ENV['OLD_COOKIE_SECRET']

use Unicorn::WorkerKiller::MaxRequests, 256, 512
use Unicorn::WorkerKiller::Oom, 120 * 1024**2, 160 * 1024**2
use Rack::Health
run Rails.application
