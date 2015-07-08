class CreateSigns < ActiveRecord::Migration
  def change
    create_table :signs do |t|
      t.string :email, null: false
      t.string :token
      t.datetime :expires_at, null: false

      t.timestamps null: false
    end

    add_index :signs, [:email], unique: true
    add_index :signs, [:token], unique: true
  end
end
