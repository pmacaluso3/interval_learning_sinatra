class User < ActiveRecord::Base
  has_many :games, foreign_key: :player_id
  has_many :decks, through: :games
  has_many :guesses

  include BCrypt

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    password_digest = @password
  end

  def authenticate(test_password)
    password == test_password
  end
end
