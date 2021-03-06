get '/decks/:deck_id/cards' do
  @deck = Deck.find(params[:deck_id])
  @game = @deck.game_for_user(current_user)
  @cards = @deck.cards.study_order
  haml :'cards/index'
end

get '/decks/:deck_id/cards/new' do
  @deck = current_user.created_decks.find(params[:deck_id])
  haml :'cards/new'
end

get '/decks/:deck_id/cards/:card_id/edit' do
  @deck = Deck.find(params[:deck_id])
  @card = current_user.created_cards.find(params[:card_id])
  haml :'cards/edit'
end

post '/decks/:deck_id/cards' do
  card = Card.create(params[:card].merge(creator_id: current_user.id, deck_id: params[:deck_id]))

  if request.xhr?
    haml :'cards/_row', locals: { card: card, deck: Deck.find(params[:deck_id]) }, layout: false
  else
    redirect "/decks/#{params[:deck_id]}/cards"
  end

end

put '/decks/:deck_id/cards/:card_id' do
  card = current_user.created_cards.find(params[:card_id])
  card.update(params[:card])

  redirect "/decks/#{params[:deck_id]}/cards"
end

delete '/decks/:deck_id/cards/:card_id' do
  card = current_user.created_cards.find(params[:card_id])
  card.destroy

  redirect "/decks/#{params[:deck_id]}/cards"
end
