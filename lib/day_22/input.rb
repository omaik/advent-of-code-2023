module Day22
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map do |line|
          Cube.new(line)
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end


  class Cube
    attr_reader :x, :y, :z

    def initialize(line)
      x1, y1, z1, x2, y2, z2 = line.match(/(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/).captures.map(&:to_i)

      @x = (x1..x2)
      @y = (y1..y2)
      @z = (z1..z2)
    end

    def intersects?(other)
      x.overlaps?(other.x) && y.overlaps?(other.y)
    end

    def blocked?(other)
      return false if equal?(other)

      new_z = ((z.begin - 1)..(z.end - 1))
      x.overlaps?(other.x) && y.overlaps?(other.y) && new_z.overlaps?(other.z)
    end

    def move_down(x)
      @z = ((z.begin - x)..(z.end - x))
    end
  end
end
