class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.integer :game_id, null: false
      t.integer :card_id, null: false
      t.datetime :repeat_at, null: false # TODO: default to now
      t.integer :times_correct, null: false, default: 0 # TODO: make an enum tied to model constant

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
