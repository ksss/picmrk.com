class Sign < ActiveRecord::Base
  class DBError < StandardError; end

  EXPIRES_AT_MINUTES = 15.minutes

  class << self
    def start(email)
      create(
        email: email,
        token: new_token,
        expires_at: new_expires_at,
      )
    end

    def new_token
      Base58.key_digest58(32)
    end

    def new_expires_at
      now + EXPIRES_AT_MINUTES
    end

    def now
      Time.zone.now
    end
  end

  def start
    success = update(
      token: Sign.new_token,
      expires_at: Sign.new_expires_at,
    )
    if success
      self
    else
      raise DBError, "update failed"
    end
  end

  def expired?
    self.expires_at < Sign.now
  end

  def deauthorize
    update(
      token: nil,
      expires_at: Sign.now
    )
  end
end
