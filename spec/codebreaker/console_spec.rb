require 'spec_helper'
require_relative '../../lib/codebreaker/console'
require_relative '../../lib/codebreaker/game'

module Codebreaker
  describe Console do

    let(:console) { Codebreaker::Console.new }

    context "start_game" do

      before do
        allow(console).to receive(:attempt)
      end

      it "creates a new game" do
        console.start_game
        expect(console.instance_variable_get(:@game)).to be_a Game
      end

      it "calls attempt" do
        expect(console).to receive(:attempt)
        console.start_game
      end

    end

    context "attempt" do

      after do
        console.attempt
      end

      it "calls method guess if answer match 4 numbers" do
        allow(console).to receive(:gets).and_return("1234")
        expect(console).to receive(:guess).with("1234")
      end

      it "calls hint" do
        allow(console).to receive(:gets).and_return("h")
        expect(console).to receive(:hint)
      end

      it "calls attempt if answer is incorrect" do
        allow(console).to receive(:gets).and_return("word")
        expect(console).to receive(:attempt)
      end

      it "rescues if size numbers is incorrect" do
        allow(console).to receive(:gets).and_return("12345")
        expect(console).to receive(:attempt)
      end

    end

    context "guess" do

      before do
        console.instance_variable_set(:@game, Game.new)
      end

      after do
        console.guess("1234")
      end

      it "calls #possible_win if attempts > 1" do
        expect(console).to receive(:possible_win).with("1234")
      end

      it "calls #last_attempt if attempts = 1" do
        console.instance_variable_get(:@game).instance_variable_set(:@attempts, 1)
        expect(console).to receive(:last_attempt).with("1234")
      end

    end

    context "#possible_win" do

      before do
        console.instance_variable_set(:@game, Game.new)
        console.instance_variable_get(:@game).instance_variable_set(:@secret_code, [1,2,3,4])
      end

      it "checks if user has won" do
        expect(console).to receive(:win_message)
        expect(console).to receive(:game_over)
        console.possible_win("1234")
      end

      it "calls #attempt if user had not guessed the code" do
        expect(console).to receive(:left_attempts_message)
        expect(console).to receive(:attempt)
        console.possible_win("1243")
      end

    end

    context "#last_attempt" do

      before do
        console.instance_variable_set(:@game, Game.new)
        console.instance_variable_get(:@game).instance_variable_set(:@secret_code, [1,2,3,4])
      end

      it "checks if user has won" do
        expect(console).to receive(:win_message)
        expect(console).to receive(:game_over)
        console.last_attempt("1234")
      end

      it "calls #attempt if user had not guessed the code" do
        expect(console).to receive(:game_over)
        console.last_attempt("1243")
      end

    end

    context "hint" do

      before do
        allow(console).to receive(:attempt)
      end

      it "calls @game.hint" do
        console.start_game
        expect(console.instance_variable_get(:@game)).to receive(:hint)
        console.hint
      end

      # does not work
      # it "opens 1 number if hints > 0" do
      #   console.start_game
      #   console.instance_variable_get(:@game).instance_variable_set(:@rand_index, 0)
      #   console.instance_variable_get(:@game).instance_variable_set(:@secret_code, [1,2,3,4])

      #   expect(console.hint).to eq ("1***")
      # end

      it "does not open 1 number if hint = 0" do
        console.start_game
        console.instance_variable_get(:@game).instance_variable_set(:@hints, 0)
        expect(console.hint).to eq(nil)
      end
    end

    context "game_over" do

      it "calls #play_again" do
        expect(console).to receive(:play_again)
        console.game_over
      end

    end

    context "play_again" do

      it "calls #start_game if answer 'y'" do
        allow(console).to receive(:gets).and_return("y")
        expect(console).to receive(:start_game)
        console.play_again
      end

    end

  end
end