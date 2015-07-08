class Following < ActiveRecord::Base
  validates_uniqueness_of :from, scope: :to
  validates :from, presence: true
  validates :to, presence: true

  belongs_to :from, class_name: 'Account'
  belongs_to :to, class_name: 'Account'
end
