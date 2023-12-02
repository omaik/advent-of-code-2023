module Day2
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map do |line|
          Game.new(line)
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Game
    attr_reader :id, :turns

    def initialize(line)
      @id, @turns = line.split(': ')
      @id = @id.match(/\d+/)[0].to_i

      @turns = @turns.split('; ').map do |turn|
        turn.split(',').to_h do |item|
          item.match(/(\d+) (\w+)/)[1..2].reverse
        end.transform_values(&:to_i)
      end
    end
  end
end
