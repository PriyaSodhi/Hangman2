require_relative '../play'

describe "Play" do
  subject(:play_instance) { Play.new(game_state, ui) }
  let(:game_state) do
    instance_double(HangmanGameState,
      :lives => 8,
      :word => 'Ruapehu',
      :guesses => guesses,
      :clue => clue,
      :remaining_lives => remaining_lives
    )
  end

  let(:ui) do
    instance_double(HangmanConsoleUi,
    :display_game_state => game_state,
    :get_guess_from_player => guess
  )
  end

  let(:turn_result) do
    instance_double(TurnResult)
  end

  describe "#play_game" do
    subject(:play_game) { play_instance.play_game }

    let(:guesses) { [] }
    let(:clue) { [] }
    let(:remaining_lives) { 4 }

    context "when the game is not in progress" do
      let(:guess) { nil }

      it "will display the intial state of the game " do
        allow(game_state).to receive(:game_in_progress?).and_return(false)
        expect(ui).to receive(:display_game_state).with(game_state)
        play_game
      end
    end

    context "when the game is in progress" do
      before do
        allow(game_state).to receive(:game_in_progress?).and_return(true, false)
        allow(game_state).to receive(:process_guess).with(guess).
        and_return(turn_result)
      end

      context "and the player guessed the correct letter" do
        let(:guess) { 's' }

        it "will display guess state and game state as per correct guess" do
          expect(ui).to receive(:display_guess_state).with(turn_result)
          expect(ui).to receive(:display_game_state).with(game_state)
          play_game
        end
      end

      context "and the player guessed the incorrect letter" do
        let(:guess) { 'w' }

        it "will display guess state and game state as per incorrect guess " do
          expect(ui).to receive(:display_guess_state).and_return(turn_result)
          expect(ui).to receive(:display_game_state).and_return(game_state)
          play_game
        end
      end

      context "and the player guessed the invalid letter" do
        let(:guess) { '@' }

        it "will display guess state and game state as per invalid guess" do
          expect(ui).to receive(:display_guess_state).and_return(turn_result)
          expect(ui).to receive(:display_game_state).and_return(game_state)
          play_game
        end
      end

      context "and the player guessed the duplicate letter" do
        let(:guess) { 'w' }
        let(:guesses) { ['w', 't'] }

        it "will display guess state and game state as per duplicate guess" do
          expect(ui).to receive(:display_guess_state).and_return(turn_result)
          expect(ui).to receive(:display_game_state).and_return(game_state)
          play_game
        end
      end
    end
  end
end
