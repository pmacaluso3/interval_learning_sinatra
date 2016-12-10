module DecksHelpers
  def recently_played_games
    current_user.games
                .includes(:deck, :guesses)
                .order('last_played_at DESC')
  end
end

helpers DecksHelpers
