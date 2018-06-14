require_relative '../hangman_game_state'
require_relative '../hangman_console_ui'
require 'byebug'

require 'rspec'

RSpec.describe HangmanGameState do
  let(:lives) { 8 }
  let(:remaining_lives) { 8 }
  let(:word) { "bangladesh" }
  let(:guesses) { [] }
  let(:guess) { 'a' }
  subject(:game) { HangmanGameState.new(word, lives) }

  describe "#attempt_guess" do
    let(:validate_guess) { game.attempt_guess(guess) }

    context "#invalid_guess?" do
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
          expect(game).to_not be_won
        end
      end

      context "and the player guesses the right letter" do
        let(:guess) { 'f' }

        it "will return false" do
          expect(game).to_not be_won
        end
      end

      context "and the player made correct guesses" do
        before do
          %w(i e f q r l x a v u).each do |guess|
            game.attempt_guess(guess)
          end
        end

        it "will return true" do
          expect(game).to be_won
        end
      end
    end

    context "when the player has no lives remaining" do

      context "and the player made all posssible guesses" do
        before do
          %w(q w e r t y z x ).each do |guess|
            game.attempt_guess(guess)
          end
        end

        it "will return false" do
          expect(game).to_not be_won
        end
      end
    end
  end

  describe "#lost?" do
    let(:word) { "flux" }
    let(:game_lost) { game.lost? }

    context "when the player has started the game" do

      it "will return false" do
        expect(game).to_not be_lost
      end
    end

    context "when the player has lives remaining" do
      before do
        game.attempt_guess(guess)
      end

      context "and the player guessed the wrong letter" do
        let(:guess) { 'q' }

        it "returns false" do
          expect(game).to_not be_lost
        end
      end

      context "and the player guessed the right letter" do
        let(:guess) { 'f' }

        it "returns false" do
          expect(game).to_not be_lost
        end
      end

      context "and the player made correct guesses " do
        before do
          %w(f w x t l y s u p).each do |guess|
            game.attempt_guess(guess)
          end
        end

        it "will return false" do
          expect(game).to_not be_lost
        end
      end
    end

    context "when the player has no lives remaining" do

      context "and the player made all possibles guesses" do
        before do
          %w(q w e r t y s o i p).each do |guess|
            game.attempt_guess(guess)
          end
        end

        it "will return true" do
          expect(game).to be_lost
        end
      end
    end
  end

  describe "#game_in_progress?" do
    let(:word) { "Hello" }
    subject(:game_in_progress) { game.game_in_progress? }

    context "when player has neither won nor lost the game" do
      before do
        %w(r h l k).each do |guess|
          game.attempt_guess(guess)
        end
      end

      it "returns true" do
        expect(game).to be_game_in_progress
      end
    end

    context "when the player has not won, but lost the game" do
      before do
        %w(r h l k y s u p q t).each do |guess|
          game.attempt_guess(guess)
        end
      end

      it "returns false" do
        expect(game).to_not be_game_in_progress
      end
    end

    context "the player has attempted to make guesses" do

      before do
        %w(q w r g f d s a v e h l o).each do |guess|
           game.attempt_guess(guess)
        end
      end

      context "but the player has no lives remaining" do
        it "raises an error" do
          expect{ game_in_progress }.to raise_error(ArgumentError, "word is guessed correctly but remaining lives are 0")
        end
      end
    end
  end

  describe "#remaining_lives" do
    let(:word) { "Ruapehu" }

    context "when player guessed a correct letter" do
      let(:guess) { 'e' }

      it "will not change the remaining_lives" do
        expect {
          game.attempt_guess(guess)
        }.not_to change{
          game.remaining_lives
        }
      end
    end

      context "when player guessed an incorrect letter" do
      let(:guess) { 'q' }

      it "will decrement remaining_lives by 1" do
        expect {
          game.attempt_guess(guess)
        }.to change{
          game.remaining_lives
        }.by(-1)
      end
    end
  end

  describe "#clue" do
    let(:word) { "Ruapehu" }

    context "when the game just started " do

      it "will build the initial clue" do
        expect(game.clue).to eq [nil]*word.length
      end
    end

    context "when the player made correct guess " do
      let(:guess) { 'e' }

      it "will add the guess to the clue " do
        expect {
          game.attempt_guess(guess)
        }.to change{
        game.clue }.from([nil]*word.length).to([nil, nil, nil, nil, 'e', nil, nil])
      end
    end

    context "when player made incorrect guess" do
      let(:guess) { 'z' }

      it "will not make any changes to the clue" do
        expect(game.clue).to eq [nil]*word.length
      end
    end
  end
end
