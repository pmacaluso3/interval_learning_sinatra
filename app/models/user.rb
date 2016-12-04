class User < ActiveRecord::Base
  has_many :created_decks, class_name: :Deck, foreign_key: :creator_id
  has_many :created_cards, class_name: :Card, foreign_key: :creator_id
  has_many :games, foreign_key: :player_id
  has_many :played_decks, through: :games, source: :deck
  has_many :guesses

  validates :email, presence: true, uniqueness: true

  include BCrypt

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end

  def authenticate(test_password)
    if password == test_password
      true
    else
      self.errors.add(:password, 'Invalid login')
      false
    end
  end
end
