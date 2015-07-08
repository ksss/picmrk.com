class AccountStream < ActiveRecord::Base
  belongs_to :account
  belongs_to :stream

  validates_uniqueness_of :account_id, scope: :stream_id

  def owner?
    status == 'owner'
  end

  def viewer?
    status == 'viewer'
  end
end
