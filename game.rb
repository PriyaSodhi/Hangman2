# Language: Ruby, Level: Level 3
load 'hangman.rb'

hangman = Hangman.new(8)
# hangman.play
# hangman.display_invalid_guess_error(nil)
# hangman.display_duplicate_guess_error(nil)
# hangman.display_correct_guess_message(nil)
# hangman.display_incorrect_guess_message(nil)
# puts hangman.get_random_word
# puts hangman.get_guess_from_player
# hangman.display_clue('Hello', ['l','h','a'])
# puts hangman.guess_correct?('r', 'Ruby') # should be true
# puts hangman.guess_correct?('k', 'Ruby') # should be false
# hangman.display_previous_guesses(['l','h','a'])
# puts hangman.game_over?("Hello", ['l','h','e', 'o'], 8)
# puts hangman.game_over?("Hello", ['l','h','e','o'])
puts hangman.display_game_result("Hello", ['l','h','e','o'], 8)


# valid_guess = hangman.valid_guess?('L')
# duplicate_guess = hangman.duplicate_guess?('l', ['k', 'l', 'o'])
# puts "valid #{valid_guess}"
# puts "invalid #{duplicate_guess}"
# puts "random word #{random_word}"