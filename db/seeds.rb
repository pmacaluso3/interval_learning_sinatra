[User, Deck, Card, Game, Guess].each do |klass|
  klass.destroy_all
end

user = User.create(email: 'pete@pete.com', password: 'pete')

deck = Deck.create(name: 'German Vocab', creator: user)

Card.create(question: 'dog', answer: 'der Hund', creator: user, deck: deck)
Card.create(question: 'cat', answer: 'die Katze', creator: user, deck: deck)

game = Game.create(player: user, deck: deck)
game.sync_guesses_with_deck
