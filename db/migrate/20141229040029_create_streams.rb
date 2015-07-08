class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :key, null: false
      t.string :title, null: false
      t.json :log, null: false

      t.timestamps null: false
    end
    add_index :streams, [:key], unique: true
  end
end
