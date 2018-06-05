require_relative 'hangman_game_state.rb'
require_relative 'hangman_console_ui.rb'
require_relative 'turn_result.rb'
require_relative 'clue_builder.rb'
require 'byebug'
=begin
The purpose of play class
1. Controls the flow of the game
=end

class Play

  attr_reader :game_state, :hangman_ui

  def initialize(game_state, ui)
    @game_state = game_state
    @hangman_ui = ui
  end

  def play
    turn_result = start_game

    while turn_result.game_in_progress? do
      hangman_ui.display_subsequent_turn(turn_result.remaining_lives, turn_result.guesses, turn_result.clue)
      guess = hangman_ui.get_guess_from_player
      turn_result = play_turn(guess)
      hangman_ui.display_turn_result_message(guess, turn_result.result_of_guess_state)
    end

    if turn_result.won?
      hangman_ui.display_won_message(game_state.word)
    elsif turn_result.lost?
      hangman_ui.display_lost_message
    end
  end

  private
  def start_game
    clue = ClueBuilder.build_clue(game_state.word, game_state.guesses)
    TurnResult.new("game_just_started", game_state.lives, game_state.guesses, clue, game_state.word)
  end

  def play_turn(guess)
    guess_result = game_state.attempt_guess(guess)
    TurnResult.new(
      guess_result,
      game_state.remaining_lives,
      game_state.guesses,
      ClueBuilder.build_clue(game_state.word, game_state.guesses),
      game_state.word
    )
    end
end
