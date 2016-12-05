user = User.create(email: 'pete@pete.com', password: 'pete')

deck = Deck.create(name: 'German Vocab')

binding.pry

deck.cards.create(question: 'dog', answer: 'der Hund', creator_id: user.id)
deck.cards.create(question: 'cat', answer: 'die Katze', creator_id: user.id)

game = Game.create(user: user, deck: deck)
game.sync_guesses_with_deck
