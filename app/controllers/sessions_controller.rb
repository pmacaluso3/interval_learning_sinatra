post '/sessions' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/decks'
  else
    @user_errors = ['Invalid Login']
    @decks = Deck.all
    haml :'decks/index'
  end
end

delete '/sessions' do
  session[:user_id] = nil
  redirect '/decks'
end
