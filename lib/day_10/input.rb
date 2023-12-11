module Day10
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map.with_index do |line, y|
          line.split('').map.with_index do |char, x|
            Connector.new(char, y, x)
          end
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Connector
    attr_reader :char, :y, :x

    def initialize(char, y, x)
      @char = char
      @y = y
      @x = x
    end

    def start
      [[y - 1, x], [y, x - 1], [y + 1, x], [y, x + 1]].reject do |y, x|
        y.negative? || x.negative?
      end
    end

    def links
      case char
      when 'F'
        [[y + 1, x], [y, x + 1]]
      when '|', 'S'
        [[y + 1, x], [y - 1, x]]
      when '-'
        [[y, x + 1], [y, x - 1]]
      when 'J'
        [[y, x - 1], [y - 1, x]]
      when 'L'
        [[y, x + 1], [y - 1, x]]
      when '7'
        [[y, x - 1], [y + 1, x]]
      when '.'
        []
      else
        raise "Unknown char: #{char}, #{y}, #{x}"

      end
    end
  end
end
