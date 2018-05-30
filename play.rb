require_relative 'hangman.rb'
require_relative 'hangman_console_ui.rb'
require 'byebug'
=begin

=end
class Play

  attr_reader :hangman, :hangman_ui

  def initialize(hangman, ui)
    @hangman = hangman
    @hangman_ui = ui
  end

  def play
    turn_result = start_game

    while turn_result.game_in_progress? do

      hangman_ui.display_start_of_turn(turn_result.remaining_lives, turn_result.guesses, turn_result.clue)
      guess = hangman_ui.get_guess_from_player
      turn_result = play_turn(guess)

      case turn_result.result_of_guess_state
      when :invalid_guess
        hangman_ui.display_invalid_guess_message(guess)
      when :duplicate_guess
        hangman_ui.display_duplicate_guess_message(guess)
      when :guess_correct
        hangman_ui.display_correct_guess_message(guess)
      when :guess_incorrect
        hangman_ui.display_incorrect_guess_message(guess)
      end
    end

    if turn_result.won?
      hangman_ui.display_won_message
    elsif turn_result.lost?
      hangman_ui.display_lost_message
    end
  end

  def start_game
    clue = hangman.build_clue
    TurnResult.new("game_just_started", hangman.lives, hangman.guesses, clue, hangman.word)
  end

  def play_turn(guess)
    TurnResult.new(
      hangman.validate_guess(guess),
      hangman.remaining_lives,
      hangman.guesses,
      hangman.build_clue,
      hangman.word)
    end
  end
