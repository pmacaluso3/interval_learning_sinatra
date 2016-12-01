class Card < ActiveRecord::Base
  has_many :guesses
  belongs_to :creator, class_name: :User

  def check(test_answer)
    answer.downcase == test_answer.downcase
  end
end
