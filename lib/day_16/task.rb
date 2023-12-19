module Day16
  class Task
    def initialize(sample)
      @sample = sample
    end

    DIRECTIONS = %i[up right down left]

    def call1
      @visitors = Set.new
      @cache = []
      @entrances = 0
      @total_size = 0

      go_to_next_tile([0, 0], :right)
      @visitors.size
    end

    # 8311 - too low
    # 8331 - correct
    def call2
      starts = [
        [[0, 0], :right],
        [[0, 0], :down],
        [[0, input.first.size - 1], :left],
        [[0, input.first.size - 1], :down],
        [[input.size - 1, 0], :right],
        [[input.size - 1, 0], :up],
        [[input.size - 1, input.first.size - 1], :left],
        [[input.size - 1, input.first.size - 1], :up]
      ]

      1.upto(input.first.size - 1) do |i|
        starts << [[0, i], :down]
      end

      1.upto(input.size - 1) do |i|
        starts << [[i, 0], :right]
      end

      1.upto(input.size - 1) do |i|
        starts << [[i, input.first.size - 1], :left]
      end

      1.upto(input.first.size - 1) do |i|
        starts << [[input.size - 1, i], :up]
      end

      @recursive_cache = {}

      starts.map do |start|
        p start
        @visitors = Set.new
        @cache = {}
        @start = start

        go_to_next_tile(*start)

        @visitors.size
      end.max
    end

    def go_to_next_tile(location, direction)
      return @visitors += @recursive_cache[[location, direction]] if @recursive_cache.key?([location, direction])
      return Set.new if outside?(location)

      if @cache.key?([location, direction])
        @cycle_happened = true
        return (@visitors - @cache[[location, direction]]) + Set.new([location])
      end

      current_tile = input.dig(*location)

      @visitors << location
      @cache[[location, direction]] = @visitors.deep_dup

      steps_made = Set.new

      steps_made << location

      case current_tile
      when '.'
        steps_made += go_to_next_tile(next_location(location, direction), direction)
      when '|'
        if %i[up down].include?(direction)
          steps_made += go_to_next_tile(next_location(location, direction), direction)
        else
          steps_made += go_to_next_tile(next_location(location, :up), :up)
          steps_made += go_to_next_tile(next_location(location, :down), :down)
        end
      when '-'
        if %i[left right].include?(direction)
          steps_made += go_to_next_tile(next_location(location, direction), direction)
        else
          steps_made += go_to_next_tile(next_location(location, :left), :left)
          steps_made += go_to_next_tile(next_location(location, :right), :right)
        end
      when '\\'
        directions = {
          up: :left,
          left: :up,
          down: :right,
          right: :down
        }
        new_direction = directions[direction]

        steps_made += go_to_next_tile(next_location(location, new_direction), new_direction)
      when '/'
        directions = {
          up: :right,
          right: :up,
          down: :left,
          left: :down
        }
        new_direction = directions[direction]

        steps_made += go_to_next_tile(next_location(location, new_direction), new_direction)
      end

      # if @cycle_happened = true
      #   @cycle_happened = false
      # else
      @recursive_cache[[location, direction]] = steps_made if steps_made.size > 8000
      # end

      steps_made
    end

    def next_location(location, direction)
      case direction
      when :right
        [location[0], location[1] + 1]
      when :left
        [location[0], location[1] - 1]
      when :up
        [location[0] - 1, location[1]]
      when :down
        [location[0] + 1, location[1]]
      end
    end

    def outside?(location)
      location[0] < 0 || location[1] < 0 || location[0] >= input.size || location[1] >= input.first.size
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
