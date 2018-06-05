require 'byebug'
require_relative 'clue_builder.rb'
=begin
The Purpose of this class is
1. Validate the user input
2. Manages the remaining_lives and clue
3. Manages the cumulative state of the game
=end
class HangmanGameState

  attr_reader  :lives, :word, :guesses

  def initialize(word, lives)
    @word = word
    @lives = lives
    @guesses = []
  end

  def attempt_guess(guess)
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
end

