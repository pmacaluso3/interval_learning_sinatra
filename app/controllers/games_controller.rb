get '/games/:game_id' do
  @game = Game.find(params[:game_id])
  @game.sync_guesses_with_deck
  @cards = @game.deck.cards
  haml :'games/show'
end

put '/games/:game_id' do
  params[:cards].each do |card_id, answer_hash|
    guess = Guess.find_by(game_id: params[:game_id], card_id: card_id)
    guess.grade(answer_hash[:answer])
  end
  game =  Game.find(params[:game_id])
  deck = game.deck
  # TODO: decks/:deck_id/games should be a dashboard of decks i've played,
  # times they were played, and mastery levels (sum of times correct / total possible times correct)
  # PICKUP: redirect to decks/:deck_id/games/:game_id
  # this shows last played at, mastery level, a play button, and a link to my deck dashboard
  redirect "/decks/#{deck.id}/games/#{game.id}"
end
