require_relative '../hangman_game_state'
require_relative '../hangman_console_ui'

require 'rspec'

RSpec.describe HangmanGameState do
  let(:lives) { 8 }
  let(:remaining_lives) { 8 }
  let(:word) { "bangladesh" }
  let(:guesses) { [] }
  let(:guess) { 'a' }
  subject(:game) { HangmanGameState.new(word, lives) }

  describe "#validate_guess" do
    let(:validate_guess) { game.attempt_guess(guess) }

    context "#not a valid_guess?" do
      let(:guess) { '@' }

      it "tells the player the guess is not valid" do
        expect(validate_guess).to eq :invalid_guess
      end
    end

    context "when the player guessed the same right letter twice" do
      let(:guess) { 'b' }

      before do
        expect(game.attempt_guess(guess)).to eq :guess_correct
      end

      it "tells the player the guess is duplicate" do
        expect(game.attempt_guess(guess)).to eq :duplicate_guess
      end
    end

    context "when the player guessed the same wrong letter twice" do
      let(:guess) { 'q' }

      before do
        expect(game.attempt_guess(guess)).to eq :guess_incorrect
      end

      it "tells the player the guess is duplicate" do
        expect(game.attempt_guess(guess)).to eql :duplicate_guess
      end
    end

    context "#guess_correct" do
      let(:guess) { 'l' }
      it "tells the player the guess is correct" do
        expect(validate_guess).to eq :guess_correct
      end
    end

    context "#guess_incorrect" do
      let(:guess) { 'q' }

      it "tells the player the guess is incorrect" do
        expect(validate_guess).to eq :guess_incorrect
      end
    end
  end

  describe "#word_guessed?" do
    let(:word) { "Hello" }

    context "when the word is guessed " do
      before do
        %w(h l o e).each do |guess|
          game.attempt_guess(guess)
        end
      end

      it "returns true" do
        expect(game.word_guessed?).to be true
      end
    end

    context "when the word is not guessed" do
      before do
        %w(l z).each do |guess|
          game.attempt_guess(guess)
        end
      end

      it "returns false" do
        expect(game.word_guessed?).to be false
      end
    end
  end

  describe "#won?" do
    let(:word) { "flux" }
    let(:game_won) { game.won? }

    context "when the player has started the game" do

      it "will return false" do
        expect(game).to_not be_won
      end
    end

    context "when the player has lives remaining" do

      before do
        game.attempt_guess(guess)
      end

      context "and the player guesses the wrong letter" do
        let(:guess) { 'q' }

        it "will return false" do
          expect(game_won).to be false
        end
      end

      context "and the player guesses the right letter" do
        let(:guess) { 'f' }

        it "will return false" do
          expect(game_won).to be false
        end
      end
    end

    context "when the player has no lives remaining" do

      context "and the player made all posssible guesses" do
        before do
          game.validate_guess('q')
          game.validate_guess('w')
          game.validate_guess('e')
          game.validate_guess('t')
          game.validate_guess('f')
          game.validate_guess('y')
          game.validate_guess('s')
          game.validate_guess('o')
          game.validate_guess('p')
        end

        it "will return false" do
          expect(game_won).to be false
        end
      end

      context "and the player made correct guesses" do
        before do
          game.validate_guess('f')
          game.validate_guess('w')
          game.validate_guess('x')
          game.validate_guess('t')
          game.validate_guess('l')
          game.validate_guess('y')
          game.validate_guess('s')
          game.validate_guess('u')
          game.validate_guess('p')
        end

        it "will return true" do
          expect(game_won).to be true
        end
      end
    end
  end

  describe "#lost?" do
    let(:word) { "flux" }
    let(:game_lost) { game.lost? }

    context "when the player has started the game" do

      it "will return false" do
        expect(game_lost).to be false
      end
    end

    context "when the player has lives remaining" do
      before do
        game.validate_guess(guess)
      end

      context "and the player guessed the wrong letter" do
        let(:guess) { 'q' }

        it "returns false" do
          expect(game_lost).to be false
        end
      end

      context "and the player guessed the right letter" do
        let(:guess) { 'f' }

        it "returns false" do
          expect(game_lost).to be false
        end
      end
    end

    context "when the player has no lives remaining" do

      context "and the player made all possibles guesses" do

        before do
          game.validate_guess('q')
          game.validate_guess('w')
          game.validate_guess('e')
          game.validate_guess('t')
          game.validate_guess('f')
          game.validate_guess('y')
          game.validate_guess('s')
          game.validate_guess('o')
          game.validate_guess('p')
        end

        it "will return true" do
          expect(game_lost).to be true
        end
      end

      context "and the player made correct guesses " do
        before do
          game.validate_guess('f')
          game.validate_guess('w')
          game.validate_guess('x')
          game.validate_guess('t')
          game.validate_guess('l')
          game.validate_guess('y')
          game.validate_guess('s')
          game.validate_guess('u')
          game.validate_guess('p')
        end

        it "will return false" do
          expect(game_lost).to be false
        end
      end
    end
  end

  describe "#game_in_progress?" do
    let(:word) { "Hello" }
    subject(:game_in_progress) { game.game_in_progress? }

    context "when player has neither won nor lost the game" do
      before do
        game.validate_guess('r')
        game.validate_guess('h')
        game.validate_guess('l')
        game.validate_guess('k')
      end

      it "returns true" do
        expect(game_in_progress).to be true
      end
    end

    context "when the player has not won, but lost the game" do
      before do
        game.validate_guess('r')
        game.validate_guess('h')
        game.validate_guess('l')
        game.validate_guess('k')
        game.validate_guess('y')
        game.validate_guess('s')
        game.validate_guess('u')
        game.validate_guess('p')
        game.validate_guess('q')
        game.validate_guess('t')
      end

      it "returns false" do
        expect(game_in_progress).to be false
      end
    end
  end
end
