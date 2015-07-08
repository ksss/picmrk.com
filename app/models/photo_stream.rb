class PhotoStream < ActiveRecord::Base
  belongs_to :photo
  belongs_to :stream

  validates_uniqueness_of :photo_id, scope: :stream_id

  def next_photo
    pa = Photo.arel_table
    Photo.order(shot_at: :asc)
         .joins(:photo_streams)
         .where(pa[:shot_at].gt photo.shot_at)
         .where(photo_streams: {stream_id: stream_id})
         .first
  end

  def prev_photo
    pa = Photo.arel_table
    Photo.order(shot_at: :desc)
         .joins(:photo_streams)
         .where(pa[:shot_at].lt photo.shot_at)
         .where(photo_streams: {stream_id: stream_id})
         .first
  end
end
