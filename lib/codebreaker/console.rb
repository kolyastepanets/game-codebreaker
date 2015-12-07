require_relative 'game'

module Codebreaker

  class Console

    def start_game
      @game = Codebreaker::Game.new
      puts "Welcome, let's play"
      puts "Enter 4 digits from 1 to 6 to guess the secret code"
      puts "Type 'h' to find out 1 number of the secret code"
      attempt
    end

    def attempt
      answer = gets.chomp

      if /^[1-6]*$/ === answer
        guess(answer)
      elsif answer == "h"
        hint
      else
        puts "Enter please only 4 digits"
        attempt
      end
      rescue
        puts "Enter please only 4 digits size"
        attempt
    end

    def guess(answer)
      if @game.attempts > 1
        possible_win(answer)
      else
        last_attempt(answer)
      end
    end

    def possible_win(answer)
      res = @game.guess_code(answer)
        if res == "++++"
          p res
          win_message
          game_over
        else
          p res
          left_attempts_message
          attempt
        end
    end

    def last_attempt(answer)
      res = @game.guess_code(answer)
        if res == "++++"
          p res
          win_message
          game_over
        else
          p res
          game_over
        end
    end

    def hint
      if @game.hints > 0
        p @game.hint
        attempt
      else
        puts "There is no hints avaliable"
        attempt
      end
    end

    def game_over
      puts "Game over"
      play_again
    end

    def play_again
      puts "Do you want to play again? Press y/n"
      answer = gets.chomp
      start_game if answer == "y"
    end

    def win_message
      puts 'Huraaah'
    end

    def left_attempts_message
      puts "Left attempts: #{@game.attempts}"
      puts "-------------------"
    end

  end

end