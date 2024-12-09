module Day18
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map do |line|
          Instruction.new(line)
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Instruction
    attr_accessor :direction, :moves, :color, :point

    def initialize(line)
      @direction, @moves, @color = line.match(/(\w) (\d+) \((.+)\)/).captures

      @moves = @color[1..5].to_i(16)
      @direction = %w[R D L U][@color[6].to_i]
    end

    def move(point)
      @point = point
      self
    end

    def to_a
      case @direction
      when 'U'
        move_up(point)
      when 'D'
        move_down(point)
      when 'L'
        move_left(point)
      when 'R'
        move_right(point)
      end
    end

    def horizontal?
      %w[L R].include?(@direction)
    end

    def vertical?
      !horizontal?
    end

    def move_up(point)
      moves.times.map do |i|
        [point.first - (i + 1), point.last]
      end
    end

    def move_down(point)
      moves.times.map do |i|
        [point.first + (i + 1), point.last]
      end
    end

    def move_left(point)
      moves.times.map do |i|
        [point.first, point.last - (i + 1)]
      end
    end

    def move_right(point)
      moves.times.map do |i|
        [point.first, point.last + (i + 1)]
      end
    end
  end
end
