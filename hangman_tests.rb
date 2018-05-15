require_relative 'hangman'
require 'rspec'

RSpec.describe Hangman do
  let(:initial_lives) { initial_lives = 4 }
  let(:game) { Hangman.new(initial_lives, nil) }

  context "Given a new hangman game" do

    it "have lives equal to initial lives" do
      expect(game.lives).to eql initial_lives
    end

    context "#guess_correct?" do
      it "will return true for correct guess" do
        expect(game.guess_correct?('l', 'flux')).to be true
      end

      it "will return false for correct guess" do
        expect(game.guess_correct?('q','flux')).to be false
      end
    end

    context "#valid_guess?" do
      it "return true for valid guess which is only single character" do
        expect(game.valid_guess?('l')).to be true
      end

      it "return false for invalid guess" do
        expect(game.valid_guess?('hjxgsjhgs')).to be false
      end
    end

    it "return true for duplicate guess" do
      expect(game.duplicate_guess?('l', ['l', 'a', 'f'])).to be true
    end
  end

  context "When player plays hangman game" do

    it "return true if game is in progress" do
      expect(game.game_in_progress?('flux', ['l', 'o', 'f', 'x'], initial_lives)).to be true
    end

    it "return true if player guessed the word" do
      expect(game.word_guessed?('Hello', ['l', 'h', 'e', 'o'])).to be true
    end

    context "#game_over?" do
      it "returns true when player wons the game" do
        expect(game.won?('Hello', ['l', 'h', 'e', 'o'], 8)).to be  true
      end

      it "returns true when player lost the game" do
        expect(game.lost?('Hello', ['l', 'z', 'e', 'o'], 0)).to be true
      end
    end
  end
end

