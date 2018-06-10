class HangmanConsoleUi

  def get_guess_from_player
    gets.chomp.downcase
  end

  def display_game_state(game_state)
    display_lives_remaining(game_state.lives)
    display_previous_guesses(game_state.guesses) if guesses.any?
    display_clue(game_state.clue)
    print "\nGuess a letter: " # prompt_user
  end

  def display_guess_state(turn_result)

    case turn_result.result_of_guess_state
    when :invalid_guess
      display_invalid_guess_message(turn_result.guess)
    when :duplicate_guess
      display_duplicate_guess_message(turn_result.guess)
    when :guess_correct
      display_correct_guess_message(turn_result.guess)
    when :guess_incorrect
      display_incorrect_guess_message(turn_result.guess)
    end
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
