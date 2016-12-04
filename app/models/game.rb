class Game < ActiveRecord::Base
  belongs_to :player, foreign_key: :player_id
  belongs_to :deck
  has_many :guesses

  def sync_guesses_with_deck
    deck.cards.each do |card|
    end
  end
end
