class Game < ActiveRecord::Base
  belongs_to :user, foreign_key: :player_id
  belongs_to :deck
  has_many :guesses
end
