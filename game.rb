require_relative 'hangman.rb'
require_relative 'hangman_console_ui.rb'

WORD_DICTIONARY = %w"learning lollipop education image computer mobile january february
cat flower beauty light earth machine book news yahoo google internet
bangladesh india america cricket football friday sunday sunny"


hangman_ui = HangmanConsoleUi.new
# hangman = Hangman.new(WORD_DICTIONARY.sample, 7, hangman_ui)
hangman = Hangman.new("Ruby", 7, hangman_ui)
# hangman.lives = 7
# puts hangman.play_turn("Ruby", '@', ['t', 'a'], 4)
# puts hangman.play_turn("Ruby", 't', ['t', 'a'], 4)
# puts hangman.play_turn("Ruby", 'z', ['t', 'a'])
hangman.play
