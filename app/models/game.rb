class Game < ActiveRecord::Base
  belongs_to :player, foreign_key: :player_id
  belongs_to :deck
  has_many :guesses

  validates :player_id, :deck_id, presence: true

  def sync_guesses_with_deck
    extant_card_ids = deck.cards.pluck(:id)
    extant_guess_card_ids = guesses.pluck(:card_id)
    card_ids_to_add = extant_card_ids - extant_guess_card_ids
    card_ids_to_remove = extant_guess_card_ids - extant_card_ids
    guesses.where(card_id: card_ids_to_remove).destroy_all
    card_ids_to_add.each do |card_id|
      Guess.create(game: self, card_id: card_id)
    end
  end
end
