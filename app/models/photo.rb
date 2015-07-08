class Photo < ActiveRecord::Base
  tori :image do |model|
    "#{model.class.name}/#{model.key}"
  end

  tori :private_image do |model|
    "#{model.class.name}/#{model.private_name}"
  end

  has_many :photo_streams, dependent: :destroy
  has_many :streams, through: :photo_streams
  belongs_to :account

  validates :account_id, :filename, presence: true

  after_destroy do
    image.delete
  end
end
