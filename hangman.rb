# Language: Ruby, Level: Level 3
class Hangman
  WORD_DICTIONARY = %w"learning lollipop education image computer mobile january february
  cat flower beauty light earth machine book news yahoo google internet
  bangladesh india america cricket football friday sunday sunny"

  def initialize(lives)
    @lives = lives
  end

  def play
    word = get_random_word
    guesses = []

    while game_in_progress?(word, guesses, @lives) do
      display_lives_remaining(@lives)
      display_previous_guesses(guesses) if guesses.any?
      clue = build_clue(word, guesses)
      display_clue(clue)

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
        @lives -= 1
      end
    end
    display_game_result(word, guesses, @lives)
  end

  def get_random_word
    WORD_DICTIONARY.sample
  end

  def guess_correct?(guess, word)
    word.downcase.include?(guess)
  end

  def valid_guess?(guess)
    /\A[A-Za-z]\z/.match?(guess)
  end

  def duplicate_guess?(guess, guesses)
    guesses.include?(guess)
  end

  def game_in_progress?(word, guesses, lives)
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
      display_won_message(word)
    elsif lost?(word, guesses, lives)
      display_lost_message
    end
  end

  def get_guess_from_player
    print "\nGuess a letter: "
    gets.chomp.downcase
  end

  def display_invalid_guess_error(guess)
    puts "#{guess} is an invalid guess. Please enter valid guess"
  end

  def display_duplicate_guess_error(guess)
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

hangman = Hangman.new(8)
hangman.play
