class Game < ActiveRecord::Base
  belongs_to :player, foreign_key: :player_id, class_name: :User
  belongs_to :deck
  has_many :guesses

  validates :player_id, :deck_id, :last_played_at, presence: true
  # TODO: validate uniqueness of deck_id within scope of user

  before_validation :ensure_last_played_at

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

  def mastery_level
    max_correctness_level = Guess::REPEAT_INTERVALS.keys.max
    total_possible_points = guesses.count * max_correctness_level
    current_points = guesses.reduce(0) do |total, guess|
      total + guess.times_correct
    end
    (current_points.to_f / total_possible_points).round(2)
  end

  def ensure_last_played_at
    self.last_played_at ||= (created_at || Time.now)
  end
end
