require 'byebug'

class Hangman

  attr_reader :hangman_ui, :lives, :word, :guesses
  TurnResult = Struct.new(:state, :lives, :guesses, :clue, :game_in_progress)

  def initialize(word, lives, ui)
    @word = word
    @lives = lives
    @hangman_ui = ui
    @guesses = []
  end

  def play
    game_state = start_game

    while game_state[:game_in_progress] == true do
      # byebug
      hangman_ui.display_lives_remaining(game_state[:lives])
      hangman_ui.display_previous_guesses(game_state[:guesses]) if game_state[:guesses].any?
      hangman_ui.display_clue(game_state[:clue])
      guess = hangman_ui.get_guess_from_player
      game_state = play_turn(guess)

      case game_state[:state]
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

    # display_game_result(word, guesses, @lives
    if won?(word, guesses, @lives)
      hangman_ui.display_won_message(word)
    elsif lost?(word, guesses, @lives)
      hangman_ui.display_lost_message
    end
  end

  def start_game
    # byebug
    clue = build_clue(word, guesses)
    game_in_progress = game_in_progress?(word, guesses, lives)
    TurnResult.new("game_in_progress", lives, guesses, clue, game_in_progress)
  end

  def play_turn(guess)
    # byebug
    result = TurnResult.new("game_in_progress", lives, guesses, nil, nil)

      if !valid_guess?(guess)
        result[:state] = "invalid_guess"
        result[:lives] = lives
        result[:clue] = build_clue(word, guesses)
        result[:game_in_progress] = game_in_progress?(word, guesses, lives)
        return result
      end

      if duplicate_guess?(guess, guesses)
        result[:state] = "duplicate_guess"
        result[:lives] = lives
        result[:clue] = build_clue(word, guesses)
        result[:game_in_progress] = game_in_progress?(word, guesses, lives)
        return result
      end

      guesses << guess
      if guess_correct?(guess, word)
        result[:state] = "guess_correct"
        result[:lives] = lives
        result[:guesses] = guesses
        result[:clue] = build_clue(word, guesses)
        result[:game_in_progress] = game_in_progress?(word, guesses, lives)
        return result

      else
        @lives -= 1
        result[:state] = "guess_incorrect"
        result[:lives] = lives
        result[:guesses] = guesses
        result[:clue] = build_clue(word, guesses)
        result[:game_in_progress] = game_in_progress?(word, guesses, lives)
        return result
      end
    end

  def guess_correct?(guess, word)
    word.downcase.include?(guess)
  end

  def valid_guess?(guess)
    /\A[A-Za-z]\z/.match?(guess.to_s)
  end

  def duplicate_guess?(guess, guesses)
    guesses.include?(guess)
  end

  def game_in_progress?(word, guesses, lives)
    if word_guessed?(word, guesses) && lives < 1
      raise ArgumentError, "word is guessed correctly but lives are #{lives}"
    end

    !won?(word, guesses, lives) && !lost?(word, guesses, lives)
  end

  def word_guessed?(word, guesses)
    (word.downcase.chars.uniq - guesses).empty?
  end

  def lost?(word, guesses, lives)
    !word_guessed?(word, guesses) && lives < 1
  end

  def won?(word, guesses, lives)
    word_guessed?(word, guesses) && lives >= 1
  end

  def build_clue(word, guesses)
    word.chars.map do |letter|
      guesses.include?(letter.downcase) ? letter : nil
    end
  end

  def display_game_result(word, guesses, lives)
    if won?(word, guesses, lives)
      hangman_ui.display_won_message(word)
    elsif lost?(word, guesses, lives)
      hangman_ui.display_lost_message
    end
  end
end

