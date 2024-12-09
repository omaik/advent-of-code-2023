module Day18
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      call2
    end

    def call2
      array = input.deep_dup

      area = 0

      loop do
        is = array.map.with_index do |instruction, index|
          index if (instruction.direction == 'U' && array[index - 1].direction == 'L' && array[(index + 1) % array.size].direction == 'R') ||

                   (instruction.direction == 'D' && array[index - 1].direction == 'R' && array[(index + 1) % array.size].direction == 'L') ||
                   (instruction.direction == 'L' && array[index - 1].direction == 'D' && array[(index + 1) % array.size].direction == 'U') ||
                   (instruction.direction == 'R' && array[index - 1].direction == 'U' && array[(index + 1) % array.size].direction == 'D')
        end.compact

        i = is.min_by { |j| [array[(j + 1) % array.size].moves, array[j - 1].moves].min * (array[j].moves + 1) }

        break unless i

        break if array.size == 4

        left = array[i - 1]
        up = array[i]
        right = array[(i + 1) % array.size]

        if left.moves > right.moves
          left.moves -= right.moves
          area += right.moves * (up.moves + 1)
          array.delete(right)
        elsif left.moves < right.moves
          right.moves -= left.moves
          area += (left.moves * (up.moves + 1))
          array.delete(left)
        else
          area += left.moves * (up.moves + 1)
          array.delete(right)
          array.delete(left)
        end

        a = array.last
        b = array.first
        dedup(a, b, array) if %w[U D].include?(a.direction) && %w[U D].include?(b.direction)

        dupls = array.each_cons(2).to_a.index do |a, b|
          %w[U D].include?(a.direction) && %w[U D].include?(b.direction)
        end

        if dupls
          a = array[dupls]
          b = array[dupls + 1]
          dedup(a, b, array)
        end

        a = array.last
        b = array.first
        dedup(a, b, array) if %w[L R].include?(a.direction) && %w[L R].include?(b.direction)

        dupls = array.each_cons(2).to_a.index do |a, b|
          %w[L R].include?(a.direction) && %w[L R].include?(b.direction)
        end

        next unless dupls

        a = array[dupls]
        b = array[dupls + 1]
        dedup(a, b, array)
      end

      area + array.first(2).map(&:moves).map(&:next).reduce(:*)
    end

    def dedup(a, b, array)
      if a.direction == b.direction
        a.moves += b.moves
        array.delete(b)

      elsif a.moves > b.moves
        a.moves -= b.moves
        array.delete(b)
      else
        b.moves -= a.moves

        array.delete(a)
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
