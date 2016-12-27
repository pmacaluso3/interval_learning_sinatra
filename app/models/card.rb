class Card < ActiveRecord::Base
  has_many :guesses
  belongs_to :creator, class_name: :User
  belongs_to :deck

  scope :study_order, -> { includes(:guesses).order('guesses.times_correct ASC NULLS FIRST, cards.created_at DESC') }

  validates :question, :answer, :creator_id, :deck_id, presence: true

  def check(test_answer)
    answer == test_answer
  end

  def guess_for_user(user)
    if user.class == User
      guesses.find_by(player_id: user.id)
    elsif user.class == Fixnum
      guesses.find_by(player_id: user)
    end
  end
end
