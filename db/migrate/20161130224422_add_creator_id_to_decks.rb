class AddCreatorIdToDecks < ActiveRecord::Migration
  def change
    add_column :decks, :integer, :creator_id
  end
end
