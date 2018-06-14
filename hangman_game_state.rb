require 'byebug'
require_relative 'clue_builder.rb'
=begin
The Purpose of this class is
1. Validate the user input
2. Manages the remaining_lives and clue
3. Manages the entire game_state(whether its won, lost or in progress)
4. Talks to turn_result class to hold the state of each turn
=end
class HangmanGameState

  attr_reader  :lives, :word, :guesses

  def initialize(word, lives)
    @word = word
    @lives = lives
    @guesses = []
  end

  def process_guess(guess)
    result_of_guess_state = attempt_guess(guess)

    TurnResult.new(
      result_of_guess_state,
      remaining_lives,
      guess,
      guesses,
      clue,
      game_in_progress?,
      won?,
      lost?
    )
  end

  def validate_guess(guess)
    validation_result = if invalid_guess?(guess)
      :invalid_guess
    elsif duplicate_guess?(guess)
      :duplicate_guess
    else
      nil
    end
  end

  def attempt_guess(guess)
    return validate_guess(guess) if validate_guess(guess)

    if guess_correct?(guess)
      guesses << guess
      :guess_correct
    else
      guesses << guess
      :guess_incorrect
    end
  end

  def remaining_lives
    lives - incorrect_guesses.length
  end

  def game_in_progress?
    if word_guessed? && remaining_lives < 1
      raise ArgumentError, "word is guessed correctly but remaining lives are 0"
    end

    !won? && !lost?
  end

  def lost?
    !word_guessed? && remaining_lives < 1
  end

  def won?
    word_guessed? && remaining_lives >= 1
  end

  def word_guessed?
    unguessed_characters.empty?
  end

  def clue
    ClueBuilder.build_clue(word, guesses)
  end

  private
  def guess_correct?(guess)
    word.downcase.include?(guess)
  end

  def invalid_guess?(guess)
    !(/\A[A-Za-z]\z/.match?(guess.to_s))
  end

  def duplicate_guess?(guess)
    guesses.include?(guess)
  end

  def incorrect_guesses
    guesses - word.downcase.chars.uniq
  end

  def unguessed_characters
    word.downcase.chars.uniq - guesses
  end
end
