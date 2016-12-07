class AddLastPlayedAtToGames < ActiveRecord::Migration
  def change
    add_column :games, :last_played_at, :datetime, null: false
  end
end
