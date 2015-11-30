require 'spec_helper'
require_relative '../../lib/codebreaker/console'
require_relative '../../lib/codebreaker/game'

module Codebreaker
  describe Console do

    let(:console) { Codebreaker::Console.new }

    context "start_game" do

      it "creates a new game" do
        # console.start_game
        # expect(console.instance_variable_get(:@game)).to_not be_nil
      end

      it "calls attempt"

    end

    context "attempt" do
      it "calls method guess if answer match 4 numbers"
      it "calls hint"
      it "calls attempt if answer is incorrect"
      it "rescues if size numbers is incorrect"
    end

    context "guess" do
      it "gets result from #guess_code if attempts > 1"
      it "checks for win"
      it "puts result"
      it "calls game_over"
      it "puts left attempts"
      it "calls attempt"
      it "calls #game_over if attempts = 0"
    end

    context "hint" do
      it "opens 1 number if hint > 0"
      it "calls attempt"
      it "does not open 1 number if hint = 0"
    end

    context "game_over" do
      it "calls #play_again"
    end

    context "play_again" do
      it "gets answer from user"
      it "calls #start_game"
    end

  end
end