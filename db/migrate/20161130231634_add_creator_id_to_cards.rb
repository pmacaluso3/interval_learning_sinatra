class AddCreatorIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :creator_id, :integer
  end
end
