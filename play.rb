require_relative 'hangman.rb'
require_relative 'hangman_console_ui.rb'

class Play

  attr_reader :hangman, :hangman_ui

  def initialize(hangman, ui)
    @hangman = hangman
    @hangman_ui = ui
  end

  def play
    game_state = hangman.start_game

    while game_state.game_in_progress == true do
      # byebug
      hangman_ui.display_lives_remaining(game_state.lives)
      hangman_ui.display_previous_guesses(game_state.guesses) if game_state.guesses.any?
      hangman_ui.display_clue(game_state.clue)
      guess = hangman_ui.get_guess_from_player
      game_state = hangman.play_turn(guess)

      case game_state.state
      when "invalid_guess"
        hangman_ui.display_invalid_guess_error(guess)
      when "duplicate_guess"
        hangman_ui.display_duplicate_guess_error(guess)
      when "guess_correct"
        hangman_ui.display_correct_guess_message(guess)
      when "guess_incorrect"
        hangman_ui.display_incorrect_guess_message(guess)
      end
    end

    if game_state.won == true
      hangman_ui.display_won_message(word)
    elsif game_state.lost == true
      hangman_ui.display_lost_message
    end
  end
end