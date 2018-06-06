require_relative 'play'
require_relative 'hangman_console_ui'
require 'rspec'

describe Play do

  let(:ui) { instance_double(HangmanConsoleUi).as_null_object }
  let(:game_state) { instance_double( HangmanGameState, :word => word, :guesses => guesses, :lives => lives, :attempt_guess => attempt_guess, :remaining_lives => remaining_lives )}
  let(:clue_for_initial_state) { [nil] }
  let(:guesses) { [nil] }
  let(:first_turn_result) { instance_double(TurnResult, :result_of_guess_state=> result_of_initial_state, :remaining_lives => remaining_lives, :guesses=>nil, :clue => clue_for_initial_state, :game_in_progress? => game_in_progress_initial_state, :won? => false, :lost? => false )}
  let(:subsequent_turn_result) { instance_double(TurnResult, :result_of_guess_state=> result_of_guess_state, :remaining_lives => remaining_lives, :guesses=>guesses, :clue => clue_for_subsequent_turn, :game_in_progress? => game_in_progress_for_subsequent_turns, :won? => false, :lost? => false )}

  subject(:hangman_game) { Play.new(game_state, ui) }

  context "when word has one letter" do
    let(:word) { "a" }

    context "and player have one life" do
      let(:lives) { 1 }
      let(:remaining_lives) { 1 }

      context "game is started " do
        let(:result_of_initial_state) { "game_just_started" }
        let(:game_in_progress_initial_state) { false }
        let(:attempt_guess) { "true" }

        before do
          expect(TurnResult).to receive(:new).with(result_of_initial_state, lives, guesses, clue_for_initial_state, word).and_return(first_turn_result)
        end

        it "will tell the player the intiial state of the game" do
          hangman_game.play
        end

        context "player now plays the turn" do
          let(:remaining_lives) { 1 }
          let(:game_in_progress_initial_state) { true }
          let(:game_in_progress_for_subsequent_turns) { false }

          before do
            allow(ui).to receive(:get_guess_from_player).and_return(*guesses)
            expect(ui).to receive(:display_subsequent_turn).with(remaining_lives, nil , clue_for_initial_state )
            expect(ClueBuilder).to receive(:build_clue).with(word, guesses).and_return([nil], clue_for_subsequent_turn)
            expect(TurnResult).to receive(:new).with(result_of_guess_state, lives, guesses, clue_for_subsequent_turn, word).and_return(subsequent_turn_result)
          end
          context "and they guessed the correct word" do
            let(:result_of_guess_state) { "guess_correct" }
            let(:guesses) { ["a"] }
            let(:clue_for_subsequent_turn) { ["a"] }
            let(:attempt_guess) { "guess_correct" }

            it "tells the player the result of the turn is correct" do
              hangman_game.play
           end
          end

          context "and they guessed the incorrect word " do
            let(:result_of_guess_state) { "guess_incorrect" }
            let(:guesses) { ["z"] }
            let(:clue_for_subsequent_turn) { [nil] }
            let(:attempt_guess) { "guess_incorrect" }

            it "tells the player the result of the turn is incorrect"  do
              hangman_game.play
            end
          end

          context "and they guessed the invalid character" do
            let(:result_of_guess_state) { "invalid_guess" }
            let(:guesses) { ["@"] }
            let(:clue_for_subsequent_turn) { [nil] }
            let(:attempt_guess) { "invalid_guess" }

            it "tells the player the result of the turn is invalid" do
              hangman_game.play
            end
          end
        end
      end
    end
  end
end
