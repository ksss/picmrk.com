class CreatePhotoStreams < ActiveRecord::Migration
  def change
    create_table :photo_streams do |t|
      t.references :photo, index: true, null: false
      t.references :stream, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :photo_streams, :photos
    add_foreign_key :photo_streams, :streams
  end
end
