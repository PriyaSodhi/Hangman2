=begin
The purpose of Turn result class
1. Manages the state of the turn
2. Whether the game is won, lost or in progress
=end
class TurnResult

attr_reader :result_of_guess_state, :remaining_lives, :guesses, :clue, :word

  def initialize(result_of_guess_state, remaining_lives, guesses, clue, word)
    @result_of_guess_state = result_of_guess_state
    @remaining_lives = remaining_lives
    @guesses = guesses
    @clue = clue
    @word = word
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

  private
  def word_guessed?
    (word.downcase.chars.uniq - guesses).empty?
  end
end