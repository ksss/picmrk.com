class Stream < ActiveRecord::Base
  include Digest58Key

  has_many :account_streams, dependent: :destroy
  has_many :accounts, through: :account_streams
  has_many :photo_streams, dependent: :destroy
  has_many :photos, through: :photo_streams

  validates :title, :log, presence: true

  LOG_MAX_LENGTH = 5

  def write_log(message)
    if LOG_MAX_LENGTH <= log.length
      log.shift(log.length - LOG_MAX_LENGTH + 1)
    end
    log << {time: Time.now, message: message}
    save
  end
end
