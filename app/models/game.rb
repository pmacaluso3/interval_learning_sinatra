class Game < ActiveRecord::Base
  belongs_to :player, foreign_key: :player_id
  belongs_to :deck
  has_many :guesses
end
