class AddCreatorIdToDecks < ActiveRecord::Migration
  def change
    add_column :decks, :creator_id, :integer
  end
end
