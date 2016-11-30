class CreateDecks < ActiveRecord::Migration
  def change
    craete_table :decks do |t|
      t.string :name, null: false

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
