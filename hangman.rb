require 'byebug'
require_relative 'turn_result.rb'

class Hangman

  attr_reader  :lives, :word, :guesses

  def initialize(word, lives)
    @word = word
    @lives = lives
    @guesses = []
  end

  def start_game
    clue = build_clue(word, guesses)
    game_in_progress = game_in_progress?(word, guesses, lives)
    won = won?(word, guesses, lives)
    lost = lost?(word, guesses, lives)
    TurnResult.new("game_just_started", lives, guesses, clue, game_in_progress, won, lost )
  end

  def play_turn(guess)
    TurnResult.new(
      validate_guess(guess),
      remaining_lives,
      guesses,
      build_clue(word, guesses),
      game_in_progress?(word, guesses, remaining_lives),
      won?(word, guesses, remaining_lives),
      lost?(word, guesses, remaining_lives) )
    end

  def validate_guess(guess)
    if !valid_guess?(guess)
      :invalid_guess
    elsif duplicate_guess?(guess, guesses)
      :duplicate_guess
    elsif guess_correct?(guess, word)
      guesses << guess
      :guess_correct
    elsif !guess_correct?(guess, word)
      guesses << guess
      :guess_incorrect
    end
  end

  def remaining_lives
    lives - (guesses - word.downcase.chars.uniq).length
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
end

