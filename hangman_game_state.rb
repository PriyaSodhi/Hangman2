require 'byebug'
require_relative 'turn_result.rb'
=begin
The Purpose of this class is
1. Validate the user input
2. Manages the remaining_lives and clue
3. Manages the state of the game
=end
class Hangman

  attr_reader  :lives, :word, :guesses

  def initialize(word, lives)
    @word = word
    @lives = lives
    @guesses = []
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

  def guess_correct?(guess)
    word.downcase.include?(guess)
  end

  def valid_guess?(guess)
    /\A[A-Za-z]\z/.match?(guess.to_s)
  end

  def duplicate_guess?(guess)
    guesses.include?(guess)
  end

  def build_clue
    word.chars.map do |letter|
      guesses.include?(letter.downcase) ? letter : nil
    end
  end

  def start_game
    clue = build_clue
    TurnResult.new("game_just_started", lives, guesses, clue, word)
  end

  def play_turn(guess)
    TurnResult.new(
      validate_guess(guess),
      remaining_lives,
      guesses,
      build_clue,
      word )
    end
  end

