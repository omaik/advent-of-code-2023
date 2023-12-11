module Day10
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      starting = input.each_with_index do |line, _y|
        if x = line.detect { |z| z.char == 'S' }
          break x
        end
      end

      res = starting.start.map do |y, x|
        loops([starting.y, starting.x], [y, x])
      end.compact

      res.first.size / 2
    end

    def loops(starting_point, point)
      accum = [starting_point]

      current = point

      loop do
        # p accum
        # sleep 0.5
        connector = input.dig(*current)

        accepts = connector.links.detect do |l|
          l == accum.last
        end

        return nil unless accepts

        accum << current

        next_one = connector.links.reject { |l| l == accepts }.first

        return accum if next_one == accum.first

        current = next_one
      end
    end

    # 13 - wrong
    # 50 - wrong
    # 570 - not right
    # 581 - too high
    # 281 - not right
    def call2
      starting = input.each_with_index do |line, _y|
        if x = line.detect { |z| z.char == 'S' }
          break x
        end
      end

      res = starting.start.map do |y, x|
        loops([starting.y, starting.x], [y, x])
      end.compact.first

      @dead_points = []
      input.each_with_index do |line, y|
        line.each_with_index do |char, x|
          if res.include?([y, x])
            print char.char
          elsif !inside?(res, [y, x])
            print '.'
          else
            @dead_points << [y, x] unless @dead_points.include?([y, x])
            print 'I'
          end
        end
        puts
      end

      @dead_points.size
    end

    def inside?(blocks, point)
      count_of_wals = 0
      x = point.last
      enum = if point.first < input.size / 2
               point.first.downto(0)
             else
               (input.size - 1).downto(point.first)
             end
      enum.each do |y|
        next unless blocks.include?([y - 1, x])
        next unless blocks.include?([y - 1, x + 1])

        connector2 = input.dig(y - 1, x)
        connector3 = input.dig(y - 1, x + 1)

        count_of_wals += 1 if connector2.links.include?([y - 1, x + 1]) && connector3.links.include?([y - 1, x])
      end

      binding.pry if point == [137, 117]
      count_of_wals.odd?
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
