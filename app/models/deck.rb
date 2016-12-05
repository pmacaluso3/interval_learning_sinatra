class Deck < ActiveRecord::Base
  belongs_to :creator, class_name: :User
  has_many :cards

  validates :name, :creator_id, presence: true

  scope :alphabetically, -> { order(name: 'ASC') }

  def created_by?(test_user)
    creator == test_user
  end
end
