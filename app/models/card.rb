class Card < ActiveRecord::Base
  has_many :guesses
  belongs_to :creator, class_name: :User
  belongs_to :deck

  validates :question, :answer, :creator_id, :deck_id, presence: true

  def check(test_answer)
    answer.downcase == test_answer.downcase
  end
end
