class TurnResult

attr_accessor :state, :lives, :guesses, :clue, :game_in_progress, :won, :lost

  def initialize(state, lives, guesses, clue, game_in_progress, won, lost)
    @state = state
    @lives = lives
    @guesses = guesses
    @clue = clue
    @game_in_progress = game_in_progress
    @won = won
    @lost = lost
  end
end