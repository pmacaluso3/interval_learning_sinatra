get '/games' do
  return redirect '/' if !logged_in?
  @games = recently_played_games
  haml :'games/index'
end

get '/games/:game_id' do
  @game = current_user.games.find(params[:game_id])
  return redirect '/' if !@game.due_to_repeat?
  @game.sync_guesses_with_deck
  @cards = @game.guesses
                .due_to_repeat
                .includes(:card)
                .map(&:card)
                .shuffle
  haml :'games/show'
end

put '/games/:game_id' do
  game =  current_user.games.find(params[:game_id])
  deck = game.deck
  params[:cards].each do |card_id, answer_hash|
    guess = game.guesses.find_by(card_id: card_id)
    guess.grade(answer_hash[:answer])
  end
  game.update(last_played_at: Time.now)

  if request.xhr?
    @games = recently_played_games
    haml :'games/index'
  else
    redirect "/decks/#{deck.id}/games"
  end
end
