require 'byebug'

class Hangman

 attr_reader :hangman_ui, :lives, :word

  def initialize(word, lives, ui)
    @word = word
    @lives = lives
    @hangman_ui = ui
  end

  def play
    guesses = []

    while game_in_progress?(word, guesses, @lives) do
      hangman_ui.display_lives_remaining(@lives)
      # byebug
      hangman_ui.display_previous_guesses(guesses) if guesses.any?
      clue = build_clue(word, guesses)
      # byebug
      hangman_ui.display_clue(clue)

      # byebug
      guess = hangman_ui.get_guess_from_player
      if !valid_guess?(guess)
        hangman_ui.display_invalid_guess_error(guess)
        next
      end

      if duplicate_guess?(guess, guesses)
        hangman_ui.display_duplicate_guess_error(guess)
        next
      end

      guesses << guess

      if guess_correct?(guess, word)
        hangman_ui.display_correct_guess_message(guess)
      else
        hangman_ui.display_incorrect_guess_message(guess)
        @lives -= 1
      end
    end
    display_game_result(word, guesses, @lives)
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

