get '/decks' do
  @decks = Deck.all.alphabetically
  haml :'decks/index'
end

get '/decks/new' do
  @deck = Deck.new
  haml :'decks/new'
end

get '/decks/:deck_id/edit' do
  @deck = current_user.created_decks.find(params[:deck_id])
  haml :'decks/edit'
end

get '/decks/:deck_id' do
  return redirect '/decks' if !logged_in?
  return redirect '/decks' if Deck.find(params[:deck_id]).cards.empty?
  game = Game.where(
    player_id: current_user.id,
    deck_id: params[:deck_id]).first ||
  Game.create(
    player_id: current_user.id,
    deck_id: params[:deck_id]
  )

  redirect "/games/#{game.id}"
end

put '/decks/:deck_id' do
  deck = current_user.created_decks.find(params[:deck_id])
  deck.update(params[:deck])

  redirect '/decks'
end

delete '/decks/:deck_id' do
  deck = current_user.created_decks.find(params[:deck_id])
  deck.destroy

  redirect '/decks'
end

post '/decks' do
  return redirect '/decks' if !logged_in?
  Deck.create(params[:deck].merge(creator_id: current_user.id))

  redirect '/decks'
end
