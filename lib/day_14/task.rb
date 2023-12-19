module Day14
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      north_tilted = tilt(input)

      weight(north_tilted)
    end

    def call2
      weights = Hash.new { |h, k| h[k] = [] }

      res = input

      500.times do |i|
        res = cycle(res)

        w = weight(res)

        weights[w] << i + 1
      end

      # weights.select { |k, v| k < 93226 && k > 93081}.select { |x, v| v.any? { |y|  (1000000000 - y) % 38 == 0 }

    end

    def cycle(current)
      next_one = tilt(current)

      3.times do
        next_one = tilt(next_one.transpose.map(&:reverse))
      end

      next_one.transpose.map(&:reverse)
    end

    def tilt(current)
      tilted = current.deep_dup

      current.each.with_index do |row, y|
        row.each.with_index do |cell, x|
          next if cell != 'O'

          local_y = y

          loop do
            break if local_y < 1

            upper = tilted[local_y - 1][x]

            break if upper == '#'

            if upper == '.'
              tilted[local_y - 1][x] = 'O'
              tilted[local_y][x] = '.'
            end

            local_y -= 1
          end
        end
      end
      tilted
    end

    def weight(current)
      current.map.with_index do |row, y|
        row.sum do |cell|
          cell == 'O' ? current.size - y : 0
        end
      end.sum
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end


# 93226 - too high
# 93081 - too - low
# 93102 - right
# 92639 - too low
