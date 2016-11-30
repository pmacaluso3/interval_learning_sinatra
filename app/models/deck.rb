class Deck < ActiveRecord::Base
  belongs_to :creator, class_name: :User

  scope :alphabetically, -> { order(name: 'ASC') }

  def created_by?(test_user)
    creator == test_user
  end
end
