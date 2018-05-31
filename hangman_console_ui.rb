class HangmanConsoleUi

  def get_guess_from_player
    gets.chomp.downcase
  end

  def display_start_of_turn(lives, guesses, clue)
    display_lives_remaining(lives)
    display_previous_guesses(guesses) if guesses.any?
    display_clue(clue)
    print "\nGuess a letter: " # prompt_user
  end

  def display_invalid_guess_message(guess)
    puts "#{guess} is an invalid guess. Please enter valid guess"
  end

  def display_duplicate_guess_message(guess)
    puts "You have already used #{guess}. Please choose a different guess"
  end

  def display_correct_guess_message(guess)
    puts "#{guess} is a correct guess"
  end

  def display_incorrect_guess_message(guess)
    puts "Oops #{guess} is a wrong guess. Try again"
  end

  def display_previous_guesses(guesses)
    puts "The guesses you have already made : #{guesses.join(", ")}"
  end

  def display_clue(clue)
    formatted_clue = clue.map do |c|
      c.nil? ? '_' : c
    end
    puts formatted_clue.join(" ")
  end

  def display_lives_remaining(lives)
    puts "You have #{lives} lives left"
  end

  def display_won_message(word)
    puts "You Won. The word you guessed is #{word}"
  end

  def display_lost_message
    puts "You are Hanged"
  end
end
