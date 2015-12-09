module Codebreaker
  class Game

    attr_reader :hints, :attempts, :win

    def initialize(hints = 1, attempts = 10)
      @hints = hints
      @attempts = attempts
      @secret_code = (1..4).collect{ rand(1..6) }
      @rand_index = rand(0..3)
      @win = false
    end

    def guess_code(value)
      raise ArgumentError, "wrong size of values" unless value.length == 4
      raise ArgumentError, "wrong entered characters" unless value.match(/^[1-6]+$/)
      return nil unless @attempts > 0

      @attempts -= 1

      result = []

      secret_code = @secret_code.dup
      value = value.split("").map!{ |i| i.to_i }

      value.each_with_index do |val, index|
        if secret_code[index] == val
          secret_code[index] = " "
          value[index] = " "
          result << "+"
        end
      end

      secret_code.delete(" ")
      value.delete(" ")

      value.each_with_index do |val, index|
        if secret_code.include?(val)
          secret_code[secret_code.index(val)] = " "
          value[index] = " "
          result << "-"
        end
      end

      @win = true if result == ["+","+","+","+"]

      if result.empty?
        result << "No matches"
        result.join
      else
        result.join
      end
    end

    def hint
      return nil unless @hints > 0
      @hints -= 1
      secret_code = @secret_code
      result = ["*","*","*","*"]
      result[@rand_index] = secret_code[@rand_index]
      result.join
    end

    def save_to_file(user)
      raise TypeError, "user is not a string" unless user.is_a?(String)
      raise ArgumentError, "it is allowed to use a-z, A-Z, 0-9" unless user.match(/^[a-zA-Z0-9]+$/)

      file = "#{__dir__}/../../bin/saved_files/#{user}_file.mar"

      result = { "name" => user, "hints_left" => @hints, "secret_code" => @secret_code, "attempts_left" => @attempts }
      complete_result = Marshal.dump(result)
      File.open(file, 'w') { |file| file.write(complete_result) }
    end

    def read_from_file(user)
      raise TypeError, "user is not a string" unless user.is_a?(String)
      raise ArgumentError, "it is allowed to use a-z, A-Z, 0-9" unless user.match(/^[a-zA-Z0-9]+$/)

      file = "#{__dir__}/../../bin/saved_files/#{user}_file.mar"
      result = File.read(file)
      Marshal.load(result)
    end

  end
end