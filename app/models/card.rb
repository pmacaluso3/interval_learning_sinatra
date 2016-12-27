class Card < ActiveRecord::Base
  has_many :guesses
  belongs_to :creator, class_name: :User
  belongs_to :deck

  scope :study_order, -> { includes(:guesses).order('guesses.times_correct ASC NULLS FIRST, cards.created_at DESC') }

  validates :question, :answer, :creator_id, :deck_id, presence: true

  def check(test_answer)
    answer == test_answer
  end

  def guess_for_game(game)
    if game.class == Game
      guesses.find_by(game_id: game.id)
    elsif game.class == Fixnum
      guesses.find_by(game_id: game)
    end
  end

  # this does an extra lookup but may be more straightforward than guess_for_game
  def guess_for_user(user)
    if user.class == User
      game = Game.find_by(user: user, deck: deck)
      Guess.find_by(game: game, user: user)
    elsif user.class == Fixnum
      game = Game.find_by(user_id: user.id, deck: deck)
      Guess.find_by(game: game, user_id: user.id)
    end
  end
end
