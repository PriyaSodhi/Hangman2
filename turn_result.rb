class TurnResult

attr_accessor :result_of_guess_state, :remaining_lives, :guesses, :clue, :game_in_progress, :won, :lost

  def initialize(result_of_guess_state, remaining_lives, guesses, clue, game_in_progress, won, lost)
    @result_of_guess_state = result_of_guess_state
    @remaining_lives = remaining_lives
    @guesses = guesses
    @clue = clue
    @game_in_progress = game_in_progress
    @won = won
    @lost = lost
  end
end