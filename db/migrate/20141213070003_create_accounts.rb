class CreateAccounts < ActiveRecord::Migration
  def change
    enable_extension 'citext'
    create_table :accounts do |t|
      t.citext :name, null: false
      t.string :email, null: false
      t.string :icon_url

      t.timestamps null: false
    end

    add_index :accounts, [:name], unique: true
    add_index :accounts, [:email], unique: true
  end
end
