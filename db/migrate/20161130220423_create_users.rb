class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
