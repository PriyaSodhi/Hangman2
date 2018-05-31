require_relative 'hangman_game_state.rb'
require_relative 'hangman_console_ui.rb'
require_relative 'play.rb'

WORD_DICTIONARY = %w"learning lollipop education image computer mobile january february
cat flower beauty light earth machine book news yahoo google internet
bangladesh india america cricket football friday sunday sunny"


hangman_ui = HangmanConsoleUi.new
# hangman = Hangman.new(WORD_DICTIONARY.sample, 8)
hangman = Hangman.new(WORD_DICTIONARY.sample, 8)
hangman_play = Play.new(hangman, hangman_ui)
# hangman.lives = 7
hangman_play.play
