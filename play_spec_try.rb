require_relative 'play'
require_relative 'hangman_console_ui'
require 'rspec'

describe Play do

  let(:ui) { instance_double(HangmanConsoleUi).as_null_object }
  let(:game_state) { instance_double( HangmanGameState, :word => word, :guesses => guesses, :lives => lives, :attempt_guess => "guess_correct", :remaining_lives => remaining_lives )}
  let(:clue) { [nil] }
  let(:guesses) { [nil] }
  let(:first_turn_result) { instance_double(TurnResult, :result_of_guess_state=> result_of_initial_state, :remaining_lives => remaining_lives, :guesses=>nil, :clue => clue, :game_in_progress? => game_in_progress, :won? => false, :lost? => false )}
  let(:turn_result) { instance_double(TurnResult, :result_of_guess_state=> result_of_guess_state, :remaining_lives => remaining_lives, :guesses=>guesses, :clue => clue_for_turn, :game_in_progress? => game_in_progress_for_turns, :won? => false, :lost? => false )}

  subject(:hangman_game) { Play.new(game_state, ui) }

  context "when word has one letter" do
    let(:word) { "a" }

    context "and player have one life" do
      let(:lives) { 1 }
      let(:remaining_lives) { 1 }

      context "game is started " do
        let(:result_of_initial_state) { "game_just_started" }
        let(:game_in_progress) { false }
        before do
          # allow(game_state).to receive(:attempt_guess).with(*guesses).and_return(result_of_guess_state)
          expect(TurnResult).to receive(:new).with(result_of_initial_state, lives, guesses, clue, word).and_return(first_turn_result)
        end

        it "will tell the player the intiial state of the game" do
          # allow(turn_result).to receive(:game_in_progress?).and_return(false)
          hangman_game.play
        end

        context "player now plays the turn" do
          let(:result_of_initial_state) { "game_just_started" }
          let(:result_of_guess_state) { "guess_correct" }
          before do
            allow(ui).to receive(:get_guess_from_player).and_return(*guesses)

            # allow(turn_result).to receive(:game_in_progress?).and_return(true, false)
            expect(ClueBuilder).to receive(:build_clue).with(word, guesses).and_return([nil], clue_for_turn)
            expect(ui).to receive(:display_subsequent_turn).with(remaining_lives, nil , clue )
            expect(TurnResult).to receive(:new).with(result_of_guess_state, lives, guesses, clue_for_turn, word).and_return(turn_result)
          end
          context "and they guessed the correct word" do
            let(:guesses) { ["a"] }
            let(:clue_for_turn) { ["a"] }
            let(:remaining_lives) { 1 }
            let(:game_in_progress) { true }
            let(:game_in_progress_for_turns) { false }

            it "tells the player the result of the turn" do
              hangman_game.play

           end
          end
          context "and they guessed the incorrect word " do
            
          end
        end
      end
    end
  end
end

  #     context "game has started and is in progress" do
  #       before do
  #         allow(ui).to receive(:get_guess_from_player).and_return(*guesses)
  #         allow(game_state).to receive(:attempt_guess).with(*guesses).and_return(guess_result)
  #         allow(turn_result).to receive(:game_in_progress?).and_return(true)
  #         expect(ClueBuilder).to receive(:new).with(word, guesses).and_return(clue)
  #         expect(TurnResult).to receive(:new).with(guess_result, lives, guesses, clue, word).and_return(turn_result)
  #       end
  #
  #       context "and the player plays the turn and has guessed the correct word" do
  #         let(:guesses) { ["a"] }
  #         let(:clue) { ["a"] }
  #         let(:remaining_lives) { 1 }
  #         let(:guess_result) { "guess_correct" }
  #
  #         it "tells the player the result of the turn" do
  #           expect(ui).to receive(:display_subsequent_turn).with(remaining_lives, guesses, clue )
  #           hangman_game.play
  #         end
  #
  #         it "tells the player that they have won" do
  #           expect(ui).to receive(:display_won_message).with(word)
  #           allow(turn_result).to receive(:won?).and_return(true)
  #         end
  #       end
  #     end
  #   end
  # end
# end



#       context "and player have not made any guesses" do
#         let(:guesses) { [] }
#         let(:remaining_lives) { 1 }
#
#         it "tells the player the initial state of the game" do
#           hangman_game.play
#         expect(ui).to have_received(:display_start_of_turn).with(remaining_lives, guesses, clue)
#       end
#     end
#
#
#       context " and player have made a guess the correct word" do
#
#         before do
#           allow(ui).to receive(:get_guess_from_player).and_return(*guesses)
#         end
#         let(:guesses) { ["a"] }
#
#         it "tells the player the result of their turn"
#           # expect(ui).to have_received(:display_turn_result_message)
#         # end
#         it "tells the player that they have won"
#
#         # end
#       end
#     end
#   end
# end
