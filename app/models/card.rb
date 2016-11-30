class Card < ActiveRecord::Base
  has_many :guesses

  def check(test_answer)
    answer.downcase == test_answer.downcase
  end
end
