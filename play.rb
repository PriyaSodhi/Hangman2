require_relative 'hangman_game_state.rb'
require_relative 'hangman_console_ui.rb'
require_relative 'turn_result.rb'
require_relative 'clue_builder.rb'
require 'byebug'
=begin
The purpose of play class
1. Controls the flow of the game
2. It will talk to view and model
=end

class Play

  attr_reader :game_state, :hangman_ui

  def initialize(game_state, ui)
    @game_state = game_state
    @hangman_ui = ui
  end

  def play_game

    while game_state.game_in_progress? do
      hangman_ui.display_game_state(game_state)
      turn_result = take_turn
      hangman_ui.display_guess_state(turn_result)
    end

    if game_state.won?
      hangman_ui.display_won_message(game_state.word)
    else
      hangman_ui.display_lost_message
    end
  end

  private
  def take_turn
    guess = hangman_ui.get_guess_from_player
    game_state.process_guess(guess)
  end
end
