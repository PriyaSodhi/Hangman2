require 'byebug'
require_relative 'clue_builder.rb'
=begin
The Purpose of this class is
1. Validate the user input
2. Manages the remaining_lives and clue
3. Manages the entire game_state
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
    result_of_guess_state = validate_guess(guess)
    puts remaining_lives
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
    if !valid_guess?(guess)
      :invalid_guess
    elsif duplicate_guess?(guess)
      :duplicate_guess
    elsif guess_correct?(guess)
      guesses << guess
      :guess_correct
    elsif !guess_correct?(guess)
      guesses << guess
      :guess_incorrect
    end
  end

  def remaining_lives
    lives - (guesses - word.downcase.chars.uniq).length
  end

  def guess_correct?(guess) # can be private
    word.downcase.include?(guess)
  end

  def valid_guess?(guess) # can be private
    /\A[A-Za-z]\z/.match?(guess.to_s)
  end

  def duplicate_guess?(guess) # can be private
    guesses.include?(guess)
  end

  def game_in_progress?
    if word_guessed? && remaining_lives < 1
      raise ArgumentError, "word is guessed correctly but lives are #{lives}"
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
    (word.downcase.chars.uniq - guesses).empty?
  end

  def clue
    ClueBuilder.build_clue(word, guesses)
  end
end
