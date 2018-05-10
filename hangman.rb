# Language: Ruby, Level: Level 3
class Hangman
  def initialize
  end
  
  def play
    word = get_random_word
    guesses = []

    while !game_over? do
      display_previous_guesses(guesses) if guesses.any?
      display_clue(word, guesses)

      guess = get_guess_from_player
      if !valid_guess?(guess)
        display_invalid_guess_error(guess)
        next
     end

     if duplicate_guess?(guess, guesses)
       display_duplicate_guess_error(guess)
       next
     end

     guesses << guess

     if guess_correct?(guess, word)
       display_correct_guess_message(guess)
     else
       display_incorrect_guess_message(guess)
     end
   end
 end



end
