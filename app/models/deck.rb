class Deck < ActiveRecord::Base
  belongs_to :creator, class_name: :User
  has_many :cards
  has_many :games

  validates :name, :creator_id, presence: true

  scope :alphabetically, -> { order(name: 'ASC') }

  def created_by?(test_user)
    creator == test_user
  end

  def game_for_user(user)
    if user.class == User
      games.find_by(player_id: user.id)
    elsif user.class == Fixnum
      games.find_by(player_id: user)
    end
  end
end
