require_relative 'hangman.rb'
require_relative 'hangman_console_ui.rb'

hangman_ui = HangmanConsoleUi.new
hangman = Hangman.new(8, hangman_ui)
hangman.lives = 7
hangman.play
