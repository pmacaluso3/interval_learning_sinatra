get '/games/:game_id' do
  @game = Game.find(params[:game_id])
  @game.sync_guesses_with_deck
end
