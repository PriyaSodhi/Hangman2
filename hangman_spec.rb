require_relative 'hangman'
require 'rspec'

RSpec.describe Hangman do
  let(:initial_lives) { 4 }
  subject(:game) { Hangman.new(initial_lives, nil) }

  describe "#guess_correct?" do
    it "returns true for correct guess" do
      expect(game.guess_correct?('l', 'flux')).to be true
    end

    it "returns false for incorrect guess" do
      expect(game.guess_correct?('q','flux')).to be false
    end
  end

  describe "#valid_guess?" do
    context "for valid guess" do
      context "when guess is a single character" do
        it "returns true" do
          expect(game.valid_guess?('l')).to be true
        end
      end
    end

    context "for invalid guess" do
      let(:valid_guess) { game.valid_guess?(guess) }

      context "when guess is a number " do
        let(:guess) { 4 }

        it "returns false" do
          expect(valid_guess).to be false
        end
      end

        context "when guess is a special character" do
          let(:guess) { "$" }

          it "returns false" do
            expect(valid_guess).to be false
          end
        end

        context "when guess is more than one character" do
          let(:guess) { "gdsjh" }

          it "returns false" do
            expect(valid_guess).to be false
          end
        end
      end
    end

  describe "#duplicate_guess?" do
    let(:guesses) { ['l', 'a', 'f'] }

    it "return true for duplicate guess" do
      expect(game.duplicate_guess?('l', guesses)).to be true
    end

    it "return false for unused guess" do
      expect(game.duplicate_guess?('k', guesses)).to be false
    end
  end

  describe "#word_guessed?" do
    let(:word) { "Hello" }

    context 'when the word is guessed correctly' do
      let(:correctly_guessed_letters) { %w[h e l o] }

      context 'with letters ordered as they appear in the word' do
        it 'returns true' do
          expect(game.word_guessed?(word, correctly_guessed_letters))
            .to be true
        end
      end

      context 'with letters ordered differently' do
        let(:randomly_ordered_letters) { correctly_guessed_letters.shuffle }

        it 'returns true' do
          expect(game.word_guessed?(word, randomly_ordered_letters))
            .to be true
        end
      end
    end

    context "when the word is not guessed correctly" do
      it "returns false" do
        expect(game.word_guessed?(word, ['f', 'l', 'q', 'e'])).to be false
      end
    end
  end

  describe "#won?" do
    let(:word) { "flux" }
    let(:game_won) { game.won?(word, guesses, lives) }

    context "when the word is guessed" do
      let(:guesses) { word.chars }

      context "when player has lives remaining" do
        let(:lives) { 8 }

        it "returns true" do
          expect(game_won).to be true
        end
      end

      context "when player has no lives remaining" do
        let(:lives) { 0 }

        it "returns false" do
          expect(game_won).to be false
        end
      end
    end

    context "when the word is not guessed" do
      let(:guesses) { ['f', 'i', 'k'] }

      context "when player has lives remaining" do
        let(:lives) { 8 }

        it "returns false" do
          expect(game_won).to be false
        end
      end

      context "when player has no lives remaining" do
        let(:lives) { 0 }

        it "returns false" do
          expect(game_won).to be false
        end
      end
    end
  end

  describe "#lost?" do
    let(:word) { "flux" }
    let(:game_lost) { game.lost?(word, guesses, lives) }

    context "when word is not guessed" do
      let(:guesses) { ['f', 'k', 'l'] }

      context "when player has no lives remaining" do
        let(:lives) { 0 }

        it "returns true" do
          expect(game_lost).to be true
        end
      end

      context "when player has lives remaining" do
        let(:lives) { 6 }

        it "returns false" do
          expect(game_lost).to be false
        end
      end
    end

    context "when word is guessed" do
      let(:guesses) { word.chars}

      context "when player has no lives remaining" do
        let(:lives) { 0 }

        it "returns false" do
          expect(game_lost).to be false
        end
      end

      context "when player has lives remaining" do
        let(:lives) { 8 }

        it "returns false" do
          expect(game_lost).to be false
        end
      end
    end
  end

  describe "#game_in_progress?" do
    let(:word) { "Hello" }
    subject(:game_in_progress) { game.game_in_progress?(word, guesses, lives) }

    context "when player has not won the game" do
      let(:guesses) { ['a', 'e', 'w', 'h'] }

      context "and the player has not lost the game either" do
        let(:lives) { 5 }

        it "returns true" do
          expect(game_in_progress).to be true
        end
      end

      context "but the player has lost the game" do
        let(:lives) { 0 }

        it "returns false" do
          expect(game_in_progress).to be false
        end
      end
    end

    context "when player has won the game" do
      let(:guesses) { ['l', 'e', 'o', 'h'] }

      context "and the player has not lost the game either" do
        let(:lives) { 5 }

        it "returns false" do
          expect(game_in_progress).to be false
        end
      end

      context "but the player has lost the game" do
        let(:lives) { 0 }

        it "raises an error" do
          expect { game_in_progress }.to raise_error(ArgumentError, "word is guessed correctly but lives are 0")
        end
      end
    end
  end
end

