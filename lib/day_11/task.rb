module Day11
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      calculate_distances(2)
    end

    def call2
      calculate_distances(1_000_000)
    end

    def calculate_distances(galaxy_multiplier)
      find_expanding_points
      galaxies = []
      input.each_with_index do |line, y|
        line.each_with_index do |char, x|
          galaxies << [y, x] if char == '#'
        end
      end

      galaxies.combination(2).map do |a, b|
        crossed_x_lines = @x_points.count { |x|  x.between?(*[a[1], b[1]].sort) }
        crossed_y_lines = @y_points.count { |y|  y.between?(*[a[0], b[0]].sort) }

        ((a[0] - b[0]).abs + (a[1] - b[1]).abs - crossed_x_lines - crossed_y_lines) +
          crossed_y_lines * galaxy_multiplier + crossed_x_lines * galaxy_multiplier
      end.sum
    end

    def find_expanding_points
      @x_points = []
      0.upto(input.first.size - 1).each do |x|
        next unless 0.upto(input.size - 1).all? do |y|
          input[y][x] == '.'
        end

        @x_points << x
      end

      @y_points = []

      0.upto(input.size - 1).each do |y|
        next unless input[y].all? { |c| c == '.' }

        @y_points << y
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
