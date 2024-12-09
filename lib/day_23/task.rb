module Day23
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      path = [[0, 1]]

      travels = []
      @cache = {}

      travels << path
      finishes = []

      loop do
        break if travels.blank?

        path = travels.shift

        next if @cache[path.last(2)] && @cache[path.last(2)] > path.size

        if path.last == [input.size - 1, input.first.size - 2]
          finishes << path
          next
        end

        point = path.last

        moves = move(point)

        moves.each do |move|
          next if path.include?(move)

          new_path = path + [move]
          index = travels.index do |path|
            sort_score(path) >= sort_score(new_path)
          end
          travels.insert(index || -1, new_path)
        end

        @cache[path.last(2)] = path.size if narrow?(path.last)
      end

      binding.pry
    end

    def narrow?(point)
      y, x = point

      [[y, x + 1], [y, x - 1], [y + 1, x], [y - 1, x]].count do |y, x|
        input.dig(y, x) == '#'
      end >= 2
    end

    # 5134 - too low
    # 5506 - too low
    # 6210 - too low
    # 6334 - not right
    # 6442 - not right
    # 9522 - not right
    def call2
      path = [[0, 1]]

      travels = []
      @cache = {}

      travels << path
      finishes = []

      conjunctions = [[0, 1]]

      input.each_with_index do |row, y|
        row.each_with_index do |tile, x|
          conjunctions << [y, x] if tile != '#' && !narrow?([y, x])
        end
      end

      conjunctions << [input.size - 1, input.first.size - 2]

      conjunctions = conjunctions.to_h do |c|
        [c, Hash.new(0)]
      end

      ways = {}

      loop do
        break if travels.blank?

        path = travels.shift

        # next if @cache[path.last(2)] && @cache[path.last(2)] > (path.size)

        point = path.last
        if conjunctions.key?(point)
          conj_1 = point
          ind = path.reverse[1..].index do |k|
            conjunctions.key?(k)
          end

          if ind

            conj_2 = path.reverse[1..][ind]

            p [ways[[conj_2, conj_1]], ind + 1]
            if ways[[conj_2, conj_1]] && ways[[conj_2, conj_1]] >= ind + 1
              p 'rejected'
              next
            end

            ways[[conj_2, conj_1]] = ind + 1
          end
        end

        if path.last == [input.size - 1, input.first.size - 2]
          p ['finished', path.size - 1]
          # path.each_cons(2).with_index(1) do |(a, b), i|
          #   @cache[[a, b]] = i if narrow?(b) && (@cache[[a, b]] || 0) < i
          # end

          finishes << path
          next
        end

        p [point, travels.size] if rand(10_000) == 3

        moves = move2(point)

        # binding.pry if rand(1000) == 3

        moves.each do |move|
          next if path.include?(move)

          new_path = path + [move]
          index = travels.index do |path|
            sort_score(path) >= sort_score(new_path)
          end
          travels.insert(index || -1, new_path)
        end

        # @cache[path.last(2)] = path.size if narrow?(path.last)
      end

      new_ways = ways.keys.map do |k|
        { k[0] => { k[1] => ways[k] } }
      end.inject({}) do |a, b|
        a.merge(b) { |_k, old, new| old.merge(new) }
      end

      path = [[0, 1]]
      travels = [path]
      finishes = Set.new
      @cache = {}
      loop do
        path = travels.shift
        break if path.nil?

        point = path.last
        # p point
        # next if @cache[path.last(14)] && @cache[path.last(14)] > path.each_cons(2).map { |a, b| new_ways.dig(a, b) }.sum

        if point == [input.size - 1, input.first.size - 2]
          finishes << path.each_cons(2).map { |a, b| new_ways.dig(a, b) }.sum
          p finishes.max if rand(100) == 3
          p "Stack size #{travels.size} #{finishes.size}" if rand(100) == 3
          next
        end

        # @cache[path.last(14)] = path.each_cons(2).map { |a, b| new_ways.dig(a, b) }.sum if path.size >= 14

        moves = new_ways[point]
        p [path.size, path.each_cons(2).map { |a, b| new_ways.dig(a, b) }.sum] if rand(1000) == 3

        moves.sort_by { |_k, v| -v }.each do |move|
          next if path.include?(move.first)

          new_path = path + [move.first]
          index = travels.index do |path|
            graph_score(path, new_ways) >= graph_score(new_path, new_ways)
          end
          travels.insert(index || -1, new_path)
        end
      end
      binding.pry
    end

    def graph_score(path, new_ways)
     - path.size
    end
    # def call2
    #   conjunctions = [[0, 1]]

    #   input.each_with_index do |row, y|
    #     row.each_with_index do |tile, x|
    #       conjunctions << [y, x] if tile != '#' && !narrow?([y, x])
    #     end
    #   end

    #   conjunctions << [input.size - 1, input.first.size - 2]

    #   path = [[0, 1]]
    #   conjunctions.each_cons(2).map do |(a, b)|
    #     travel(a, b, path)
    #   end
    #   binding.pry
    # end

    def input
      @input ||= Input.call(@sample)
    end

    def travel(a, b, path)
      pathy = path.dup
      next_one = move2(a) - [path.last]
      p next_one

      while next_one.first != b

        next_one = move2(next_one.first).first - [path.last]
        break if next_one.blank?
        break if next_one.size > 1

        pathy << next_one.first
      end

      path.concat(pathy)
    end

    def sort_score(path)
      path.last.sum - path.size
    end

    def move2(point)
      y, x = point
      [[y, x + 1], [y, x - 1], [y + 1, x], [y - 1, x]].reject do |y, x|
        input.dig(y, x) == '#'
      end
    end

    def move(point)
      y, x = point

      p [y, x]
      tile = input[y][x]
      tiles = if tile == '.'
                [[y, x + 1], [y, x - 1], [y + 1, x], [y - 1, x]]
              else
                case tile
                when '>'
                  [[y, x + 1]]
                when '<'
                  [[y, x - 1]]
                when '^'
                  [[y - 1, x]]
                when 'v'
                  [[y + 1, x]]
                end
              end

      tiles.reject do |y, x|
        input[y][x] == '#'
      end
    end
  end
end

# path = [[0, 1]]
# travels = [path]
# finishes = []
# loop do
#   path = travels.shift
#   break if path.nil?

#   point = path.last
#   p point

#   if point == [input.size - 1, input.first.size - 2]
#     finishes << path
#     next
#   end

#   moves = new_ways[point]

#   moves.each do |move|
#     next if path.include?(move.first)

#     travels << path + [move.first]
#   end
# end

# new_ways = ways.keys.map do |k|
#   { k[0] => { k[1] => ways[k] } }
# end.inject({}) do |a, b|
#   a.merge(b) { |_k, old, new| old.merge(new) }
# end
