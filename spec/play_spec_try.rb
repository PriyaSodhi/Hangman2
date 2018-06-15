require_relative '../play'
require_relative '../hangman_console_ui'
require 'rspec'

describe Play do
  subject(:play_instance) { Play.new(game_state, ui) }
  let(:game_state) do
    instance_double(HangmanGameState,
      :initial_state => turn_result,
      :turn_result => turn_result,
      :word => 'noone cares'
    )
  end
  let(:ui) do
    instance_double(HangmanConsoleUi,
      :get_guess_from_player => 'a',
      :display_guess_state => false,
      :display_won_message => false
    )
  end

  describe '.play' do
    subject(:play) { play_instance.play }

    let(:turn_result) do
      instance_double(TurnResult,
        :game_in_progress? => false,
        :remaining_lives => 5,
        :guesses => an_empty_array,
        :clue => clue,
        :result_of_guess_state => false,
        :won? => true
      )
    end

    let(:an_empty_array) { [] }
    let(:clue) { [ ] }
    before do
      expect(turn_result).to receive(:game_in_progress?).and_return(true, false)
      expect(ui).to receive(:display_turn_result).with(5, an_empty_array, clue)
    end

    it 'advises initial state' do
      # test that the initial state comes out somewhere
      # to do that, `display_turn_result` has to get called
      # with a turn_result which has the 'initial state setttings'
      play
    end

    context 'advises state of further turns' do
      let(:guesses) { ['r', 'v', 'n', 'q'] }

      before do
        expect(ui).to receive(:display_turn_result).with(5, guesses, clue )
      end

    end
  end
end

# describe Play do
#
#   let(:ui) { instance_double(HangmanConsoleUi).as_null_object }
#   let(:game_state) { instance_double( HangmanGameState, :turn_result => nil ,:word => word, :guesses => guesses, :lives => lives, :attempt_guess => attempt_guess, :remaining_lives => remaining_lives )}
#   let(:clue_for_initial_state) { [nil] }
#   let(:guesses) { [nil] }
#   let(:first_turn_result) { instance_double(TurnResult, :result_of_guess_state=> result_of_initial_state, :remaining_lives => remaining_lives, :guesses => nil, :clue => clue_for_initial_state, :game_in_progress? => game_in_progress_initial_state, :won? => false, :lost? => false )}
#   let(:subsequent_turn_result) { instance_double(TurnResult, :result_of_guess_state=> result_of_guess_state, :remaining_lives => remaining_lives, :guesses => guesses, :clue => clue_for_subsequent_turn, :game_in_progress? => game_in_progress_for_subsequent_turns, :won? => won, :lost? => lost )}
#
#   subject(:hangman_game) { Play.new(game_state, ui) }
#
#   context "when word has one letter" do
#     let(:word) { "a" }
#
#     context "and player have one life" do
#       let(:lives) { 1 }
#       let(:remaining_lives) { 1 }
#
#       context "game is started " do
#         let(:result_of_initial_state) { "game_just_started" }
#         let(:game_in_progress_initial_state) { false }
#         let(:attempt_guess) { false }
#
#         before do
#           expect(TurnResult).to receive(:new).with(result_of_initial_state, lives, guesses, clue_for_initial_state, word).and_return(first_turn_result)
#         end
#
#         it "will tell the player the intiial state of the game" do
#           hangman_game.play
#         end
#
#         context "player now plays the turn" do
#           # let(:remaining_lives) { 1 }
#           let(:game_in_progress_initial_state) { true }
#           let(:game_in_progress_for_subsequent_turns) { false }
#           let(:won) { false }
#           let(:lost) { false }
#
#           before do
#             allow(ui).to receive(:get_guess_from_player).and_return(*guesses)
#             allow(game_state).to receive(:turn_result).with(*guesses)
#             .and_return(subsequent_turn_result)
#             expect(ui).to receive(:display_turn_result).with(remaining_lives, nil , clue_for_initial_state )
#             expect(ui).to receive(:display_guess_state).with(*guesses, result_of_guess_state)
#             expect(ClueBuilder).to receive(:build_clue).with(word, guesses).and_return([nil], clue_for_subsequent_turn)
#             expect(TurnResult).to receive(:new).with(result_of_guess_state, lives, guesses, clue_for_subsequent_turn, word).and_return(subsequent_turn_result)
#           end
#
#           context "and they guessed the correct word" do
#             let(:result_of_guess_state) { "guess_correct" }
#             let(:guesses) { ["a"] }
#             let(:clue_for_subsequent_turn) { ["a"] }
#             let(:attempt_guess) { "guess_correct" }
#             let(:won) { true }
#             let(:lost) { false }
#
#             it "tells the player the result of the turn is correct" do
#               hangman_game.play
#            end
#
#            it "tells the player that they won the game" do
#              expect(ui).to receive(:display_won_message).with(word)
#              hangman_game.play
#            end
#           end
#
#           context "and they guessed the incorrect word " do
#             let(:result_of_guess_state) { "guess_incorrect" }
#             let(:guesses) { ["z"] }
#             let(:clue_for_subsequent_turn) { [nil] }
#             let(:attempt_guess) { "guess_incorrect" }
#             let(:won) { false }
#             let(:lost) { true }
#
#             it "tells the player the result of the turn is incorrect"  do
#               hangman_game.play
#             end
#           end
#
#           context "and they guessed the invalid character" do
#             let(:result_of_guess_state) { "invalid_guess" }
#             let(:guesses) { ["@"] }
#             let(:clue_for_subsequent_turn) { [nil] }
#             let(:attempt_guess) { "invalid_guess" }
#
#             it "tells the player the result of the turn is invalid" do
#               hangman_game.play
#             end
#           end
#         end
#       end
#     end
#   end
#
#   context " when word has more than one letter" do
#     let(:word) { "ruby" }
#
#     context "and the player has more than one life " do
#       let(:lives) { 8 }
#       let(:remaining_lives) { 8 }
#
#       context "game is started " do
#         let(:result_of_initial_state) { "game_just_started" }
#         let(:game_in_progress_initial_state) { false }
#         let(:attempt_guess) { false }
#         let(:clue_for_initial_state) { [nil] * word.length }
#         let(:intial_guesses) { [nil] * word.length }
#
#         before do
#           puts "112"
#           expect(TurnResult).to receive(:new).with(result_of_initial_state, remaining_lives, intial_guesses, clue_for_initial_state, word).and_return(first_turn_result)
#         end
#
#         it "will tell the player the intiial state of the game" do
#           hangman_game.play
#         end
#
#         context "player now plays the turn" do
#           # let(:remaining_lives) { 8 }
#           let(:game_in_progress_initial_state) { true }
#           let(:game_in_progress_for_subsequent_turns) { true }
#           let(:won) { false }
#           let(:lost) { false }
#
#           before do
#             puts "128"
#
#             allow(ui).to receive(:get_guess_from_player).and_return(*guesses)
#             expect(ui).to receive(:display_turn_result).with(remaining_lives, nil, clue_for_initial_state)
#             expect(ClueBuilder).to receive(:new).with(word, *guesses).and_return([nil], clue_for_subsequent_turn)
#             expect(TurnResult).to receive(:new).with(result_of_guess_state, remaining_lives, guesses, clue_for_subsequent_turn, word).and_return(subsequent_turn_result)
#           end
#
#           context "and they guessed the correct word " do
#             let(:result_of_guess_state) { "guess_correct" }
#             let(:guesses) { ["r", "w", "u", "b", "a", "y"] }
#             let(:clue_for_subsequent_turn) { ["r", "u", "b", "y"] }
#             let(:attempt_guess) { "guess_correct" }
#             let(:won) { true }
#             let(:lost) { false }
#
#             it "tells the player the result of the turn is correct" do
#               expect(ui).to receive(:display_turn_result).with(remaining_lives, guesses, clue_for_subsequent_turn)
#               hangman_game.play
#             end
#           end
#         end
#       end
#     end
#   end
# end
