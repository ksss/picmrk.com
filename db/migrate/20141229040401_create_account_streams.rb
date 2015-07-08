class CreateAccountStreams < ActiveRecord::Migration
  def change
    create_table :account_streams do |t|
      t.references :account, index: true, null: false
      t.references :stream, index: true, null: false
      t.string :status, null: false

      t.timestamps null: false
    end
    add_foreign_key :account_streams, :accounts
    add_foreign_key :account_streams, :streams
  end
end
