get '/decks/:deck_id/cards' do
  @cards = Deck.find(params[:deck_id]).cards
  haml :'cards/index'
end

get '/decks/:deck_id/cards/new' do
  @deck = current_user.created_decks.find(params[:deck_id])
  @card = Card.new
  haml :'cards/new'
end

get '/decks/:deck_id/cards/:card_id/edit' do
  @card = current_user.created_cards.find(params[:card_id])
  haml :'cards/edit'
end

post '/decks/:deck_id/cards' do
  Card.create(params[:card].merge(creator_id: current_user.id, deck_id: params[:deck_id]))

  redirect "/decks/#{params[:deck_id]}/cards"
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
