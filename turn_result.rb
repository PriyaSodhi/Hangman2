=begin
The purpose of Turn result class
1. Manages the state of the turn
2. Whether the game is won, lost or in progress
3. Acts like an holder of the state of each turn
=end
require 'byebug'
class TurnResult

attr_reader :result_of_guess_state, :remaining_lives, :guess, :guesses, :clue, :game_in_progress, :won, :lost

  def initialize(result_of_guess_state, remaining_lives, guess, guesses, clue, game_in_progress, won, lost)
    @result_of_guess_state = result_of_guess_state
    @remaining_lives = remaining_lives
    @guess = guess
    @guesses = guesses
    @clue = clue
    @game_in_progress =  game_in_progress
    @won = won
    @lost = lost
  end
end
