require 'spec_helper'

module Codebreaker
  describe Game do

    let(:game) { Game.new }

    context "initialize" do

      it "saves secret code" do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it "saves 4 numbers secret code" do
        expect(game.instance_variable_get(:@secret_code).size).to eq(4)
      end

      it "saves secret code with numbers from 1 to 6" do
        arr = game.instance_variable_get("@secret_code")
        expect(arr[0]).to be_between(1, 6)
        expect(arr[1]).to be_between(1, 6)
        expect(arr[2]).to be_between(1, 6)
        expect(arr[3]).to be_between(1, 6)
      end

      it "equals 1 hint" do
        expect(game.hints).to eq(1)
      end

      it "has 10 attempts to play" do
        expect(game.attempts).to eq(10)
      end

    end

    context "#guess" do

      before(:each) do
        game.instance_variable_set(:@secret_code, [1,2,3,4])
      end

      it "raises error if wrong number of arguments" do
        expect{game.guess_code("12345")}.to raise_error(ArgumentError)
      end

      it "raises error if entered wrong characters" do
        expect{game.guess_code("qwer")}.to raise_error(ArgumentError)
      end

      it "returns nil when attempts = 0" do
        game.instance_variable_set(:@attempts, 0)
        expect(game.guess_code("1234")).to eq(nil)
      end

      it "decreases attempt's number each time by one" do
        expect{ game.guess_code("1234") }.to change{ game.attempts }.by(-1)
      end

      # it "returns true when won" do
      #   game.guess_code("1234")
      #   expect(game.instance_variable_get(:@win)).to eq true
      # end

      it "returns values" do
        expect(game.guess_code("1234")).to eq("++++")
      end

      it "returns values" do
        expect(game.guess_code("4321")).to eq("----")
      end

      it "returns values" do
        expect(game.guess_code("1235")).to eq("+++")
      end

      it "returns values" do
        expect(game.guess_code("5555")).to eq("No matches")
      end

      it "returns values" do
        game.instance_variable_set(:@secret_code, [1,5,5,5])
        expect(game.guess_code("2131")).to eq("-")
      end

      it "returns values" do
        expect(game.guess_code("2555")).to eq("-")
      end

      it "returns values" do
        expect(game.guess_code("1355")).to eq("+-")
      end

      it "returns values" do
        expect(game.guess_code("1243")).to eq("++--")
      end

      it "returns values" do
        expect(game.guess_code("5554")).to eq("+")
      end

      it "returns values" do
        expect(game.guess_code("5545")).to eq("-")
      end

    end

    context "#hint" do

      it "opens random number in the secret code" do
        game.instance_variable_set(:@secret_code, "1234")
        game.instance_variable_set(:@rand_index, 0)
        expect(game.hint).to eq("1***")
      end

      it "decreases hints by one" do
        expect{ game.hint }.to change{ game.hints }.by(-1)
      end

      it "returns nil if there is no hints avaliable" do
        game.instance_variable_set(:@hints, 0)
        expect(game.hint).to eq(nil)
      end

    end

    context "#save_to_file" do

      after(:all) do
        File.delete "#{__dir__}/../../bin/saved_files/nick_file.mar"
      end

      it "raises error if it is not string" do
        expect{game.save_to_file(123)}.to raise_error(TypeError)
      end

      it "raises error if it does not match a-z, A-Z, 0-9" do
        expect{game.save_to_file("qwer_")}.to raise_error(ArgumentError)
      end

      it "saves file using user name" do
        game.save_to_file("nick")
        expect(File.exist? "#{__dir__}/../../bin/saved_files/nick_file.mar").to eq true
      end

      it "has hash of data" do
        game.save_to_file("nick")

        data = File.read "#{__dir__}/../../bin/saved_files/nick_file.mar"
        result = Marshal.load data

        expect(result).to have_key("name")
        expect(result).to have_key("hints_left")
        expect(result).to have_key("secret_code")
        expect(result).to have_key("attempts_left")
      end

    end

    context "#read_from_file" do

      after(:all) do
        File.delete "#{__dir__}/../../bin/saved_files/nick_file.mar"
      end

      it "raises error if it is not string" do
        expect{game.read_from_file(123)}.to raise_error(TypeError)
      end

      it "raises error if it does not match a-z, A-Z, 0-9" do
        expect{game.read_from_file("qwer_")}.to raise_error(ArgumentError)
      end

      it "reads file" do
        game.save_to_file("nick")

        data = game.read_from_file("nick")

        expect(data).to have_key("name")
        expect(data).to have_key("hints_left")
        expect(data).to have_key("secret_code")
        expect(data).to have_key("attempts_left")
      end

    end

  end

end