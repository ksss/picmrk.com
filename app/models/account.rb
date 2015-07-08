class Account < ActiveRecord::Base
  SYSTEM_NAMES = %w(assets auth accounts sessions sign password photos streams)

  has_many :photos
  has_many :account_streams, dependent: :destroy
  has_many :streams, through: :account_streams

  validates :name, presence: true
  validates_uniqueness_of :name
  validates_format_of :email, with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i, if: :email

  class << self
    def system_name?(name)
      SYSTEM_NAMES.include?(name.to_s)
    end
  end
end
