class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :account_id, null: false
      t.string :key, null: false
      t.string :private_name, null: false
      t.string :filename, null: false
      t.integer :size
      t.string :content_type
      t.binary :original_header
      t.datetime :shot_at
      t.timestamps null: false
    end

    add_index :photos, [:account_id]
    add_index :photos, [:key], unique: true
  end
end
