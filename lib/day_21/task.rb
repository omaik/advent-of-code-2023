module Day21
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      runners = [detect('S')]

      64.times do
        new_runners = []
        runners.each do |runner|
          new_runners.concat(steps(runner))
        end

        runners = new_runners.uniq
      end
      binding.pry
    end

    # 470151595178924 - too low
    # 610321885082978 - too high
    # 610315851283087 - too high
    # 610309817513022 - too high

    def call2
      runners = [[[0, 0], detect('S')]]
      @sizes = {}
      @alt_sizes = {}
      @alt_sizes_2 = {}
      @alt_sizes_3 = {}
      @all_sizes = Hash.new { |h, k| h[k] = [] }
      @all_sizes_2 = Hash.new { |h, k| h[k] = [] }

      @cache = {}

      600.times do |i|
        p i
        new_runners = []
        runners.each do |runner|
          new_runners.concat(infinite_steps(runner))
        end

        runners = new_runners.uniq

        # binding.pry if i+1 == 110
        @all_sizes[i % 65] << runners.size
        @all_sizes_2[26501365] << runners.size
        @sizes[i + 1] = runners.size if (i + 1) % 55 == 0
        @alt_sizes[i + 1] = runners.size if (i + 1) % 54 == 1
        @alt_sizes_2[i + 1] = runners.size if (i + 1) % 108 == 1
        @alt_sizes_3[i + 1] = runners.size if (i + 1) % 131 == 0
      end

      pr(runners)

      binding.pry
    end

    def input
      @input ||= Input.call(@sample)
    end

    def infinite_steps(point)
      return @cache[point] if @cache[point]

      infinite_locations(point).select do |location|
        input.dig(*location[1]) != '#'
      end.tap do |steps|
        @cache[point] ||= steps
      end
    end

    def convert_into_abs_map(point, steps)
      map_y, map_x = point[0]

      steps.map do |step|
        [[map_y + step[0][0], map_x + step[0][1]], step[1]]
      end
    end

    def steps(point)
      locations(point).select do |location|
        input.dig(*location) != '#'
      end
    end

    def locations(point)
      y, x = point
      [[y, x + 1], [y, x - 1], [y + 1, x], [y - 1, x]].select do |y, x|
        y >= 0 && x >= 0 && y < input.size && x < input.first.size
      end
    end

    def infinite_locations(point)
      y, x = point[1]
      map_y, map_x = point[0]

      [[y, x + 1], [y + 1, x], [y - 1, x], [y, x - 1]].select do |_y_n, _x_n|
        # next true if map_y == 0 && map_x == 0

        # (y_n.abs + x_n.abs) >= (y.abs + x.abs)
        true
      end.map do |y, x|
        if y >= input.size
          [[map_y + 1, map_x], [0, x]]
        elsif x >= input.first.size
          [[map_y, map_x + 1], [y, 0]]
        elsif y < 0
          [[map_y - 1, map_x], [input.size - 1, x]]
        elsif x < 0
          [[map_y, map_x - 1], [y, input.first.size - 1]]
        else
          [[map_y, map_x], [y, x]]
        end
      end
    end

    def detect(location)
      input.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          return [row_index, cell_index] if cell == location
        end
      end
    end

    def pr(runners)
      min_bottom_map = runners.map { |x| x[0][0] }.max
      min_top_map = runners.map { |x| x[0][0] }.min

      min_left_map = runners.map { |x| x[0][1] }.min
      min_right_map = runners.map { |x| x[0][1] }.max

      binding.pry
    end
  end
end
