class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player_id, null: false
      t.integer :deck_id, null: false

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
