post '/users' do
  user = User.new(params[:user])
  if user.save
    redirect '/decks'
  else
    @user_errors = user.errors.full_messages
    @decks = Deck.all
    haml :'decks/index' 
  end
end
