module Day24
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map do |line|
          Line.new(line)
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Line
    attr_accessor :x, :y, :z, :xx, :yy, :zz

    def initialize(line)
      @x, @y, @z, @xx, @yy, @zz = line.match(/(-?\d+), (-?\d+), (-?\d+) @ (-?\d+), (-?\d+), (-?\d+)/).captures.map(&:to_i)
    end

    def find_y(new_x)
      # binding.pry
      yy.fdiv(xx) * (new_x - x) + y
    end

    def find_z(new_x)
      zz.fdiv(xx) * (new_x - x) + z
    end

    def intersection_x(other)
      xx2 = other.xx
      yy2 = other.yy
      x2 = other.x
      y2 = other.y

      (-(yy.fdiv(xx) * x) + (yy2.fdiv(xx2) * x2) + y - y2).fdiv(-yy.fdiv(xx) + yy2.fdiv(xx2))
    end

    def intersection_z(other)
      xx2 = other.xx
      zz2 = other.zz
      x2 = other.x
      z2 = other.z

      (-(zz.fdiv(xx) * x) + (zz2.fdiv(xx2) * x2) + z - z2).fdiv(-zz.fdiv(xx) + zz2.fdiv(xx2))
    end

    def in_future?(new_x)
      xx.positive? ? new_x >= x : new_x <= x
    end

    def t_coficient(new_y)
      (new_y - y).fdiv(yy)
    end

    def z_location(new_y)
      zz * t_coficient(new_y) + z
    end

    def x_position(time)
      x + (xx * time)
    end

    def y_position(time)
      y + (yy * time)
    end

    def z_position(time)
      z + (zz * time)
    end
  end
end

# (-(yy1.fdiv(xx1) * x1) + (yy2.fdiv(xx2) * x2) + y1 - y2).fdiv(-yy1.fdiv(xx1) + yy2.fdiv(xx2))
