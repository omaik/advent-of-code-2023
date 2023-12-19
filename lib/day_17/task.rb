module Day17
  class Task
    def initialize(sample)
      @sample = sample
    end

    # 1287 -- too high
    # 1275 -- too high
    # 1051 -- too high
    # 1027 - not right
    # 1035 - not right
    # 1009 - not right
    # 1008 - not right

    def call1
      @registry = [
        Traveler2.new(input, [0, 0], [:right], []),
        Traveler2.new(input, [0, 0], [:down], [])
      ]

      @finishes = []

      @was_there = Hash.new(Float::INFINITY)

      loop do
        break if @registry.empty?

        step = @registry.pop

        # p step
        # binding.pry

        if step.finished?
          @finishes << step
          next
        end
        return step.score if step.finished?

        next if @was_there[[step.position, step.direction_key]] <= (step.score)

        p [step.score, step.position] if rand(1000) == 3

        step.next_moves.each do |move|
          index = @registry.index { |x| x.sort_score < move.sort_score } || 0

          @registry.insert(index, move)
        rescue StandardError => e
          binding.pry
        end

        @was_there[[step.position, step.direction_key]] = step.score
      end
      binding.pry
    end

    # 1196 - too low
    # 1205 - too high
    # 1203 - too high
    def call2; end

    def input
      @input ||= Input.call(@sample)
    end
  end

  DIRECTIONS = %i[left up right down]

  class Traveler
    attr_accessor :position, :directions, :path_taken, :map, :score

    def initialize(map, position, directions, path_taken)
      @map = map
      @position = position
      @directions = directions
      @score = 0
      @path_taken = path_taken
    end

    def finished?
      @position == [map.size - 1, map.first.size - 1]
    end

    def sort_score
      score
    end

    def clone
      self.class.new(map, position, directions.dup, path_taken.dup).tap do |x|
        x.score = score
      end
    end

    def next_moves
      index = DIRECTIONS.index(directions.last)

      [new_move(DIRECTIONS[index - 1]),
       new_move(DIRECTIONS[(index + 1) % 4]),
       new_move(DIRECTIONS[index])].compact
    end

    def direction_key
      return rand(1000) if directions.size < 3

      local = if directions[-1] != directions[-2]
                3
              elsif directions[-2] != directions[-3]
                2
              else
                1
              end

      [local, directions[-1]]
    end

    def new_move(direction)
      return if directions.last(3).all? { |x| x == direction }

      point = new_point(direction)

      return if outside?(point)

      copy = clone

      copy.path_taken << point
      copy.position = point
      copy.score += map.dig(*point)
      copy.directions << direction
      copy
    end

    def outside?(point)
      (0..(map.size - 1)).exclude?(point.first) ||
        (0..(map.first.size - 1)).exclude?(point.last)
    end

    def new_point(direction)
      case direction
      when :left
        [position.first, position.last - 1]
      when :up
        [position.first - 1, position.last]
      when :right
        [position.first, position.last + 1]
      when :down
        [position.first + 1, position.last]
      else
        binding.pry
      end
    end
  end

  class Traveler2 < Traveler
    def next_moves
      # return [] if impossible_to_finish?

      index = DIRECTIONS.index(directions.last)
      return [new_move(directions.last)].compact if same_count < 4

      [new_move(DIRECTIONS[index - 1]),
       new_move(DIRECTIONS[(index + 1) % 4]),
       new_move(DIRECTIONS[index])].compact
    end

    def new_move(direction)
      return if directions.size >= 10 && directions.last(10).all? { |x| x == direction }

      point = new_point(direction)

      return if outside?(point)

      copy = clone

      copy.path_taken << point
      copy.position = point
      copy.score += map.dig(*point)
      copy.directions << direction
      copy
    end

    def same_count
      @same_count ||= directions.reverse.take_while { |x| x == directions.last }.size
    end

    def direction_key
      [same_count, directions.last]
    end

    def impossible_to_finish?
      (position.first == map.size - 1 && (map.first.size - 1) < position.last + (4 - same_count) && directions.last == :right) ||
        (position.last == map.first.size - 1 && (map.size - 1) < position.first + (4 - same_count) && directions.last == :down)
    end
  end
end

# input.size.times { |y|  input.first.size.times { |x| step.path_taken.include?([y, x]) ? putc('#') : putc('.') };  puts }
