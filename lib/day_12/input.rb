module Day12
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map do |line|
          Line.new(line.split(' '))
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Line
    attr_reader :chars, :conditions

    def initialize(line)
      @chars = line[0].split('')
      @conditions = line[1].split(',').map(&:to_i)
    end

    def cloned_parse
      c = chars.join

      @chars = [[c] * 5].join('?').split('')
      @conditions = conditions * 5

      parse
    end

    def parse
      @steps_cache = {}
      @total = 0
      ranges = conditions.map do |condition|
        possible_positions(condition)
      end

      first_range = ranges.first

      first_range = first_range.reject do |x|
        chars[0...x.begin].count('#').nonzero?
      end

      first_range.each do |range|
        combinations([range], ranges[1..])
      end

      @total
    end

    def combinations(path, ranges)
      range = path.last
      current_ranges = ranges.first

      winners = current_ranges.select do |x|
        x.begin - 1 > range.end && chars[(range.end + 1)..(x.begin - 1)].count('#').zero?
      end

      if ranges.size == 1
        winners = winners.select { |x| chars[(x.end + 1)..].count('#').zero? }
        @total += winners.size

        return winners.size
      end

      winners.map do |winner|
        cached = @steps_cache[[winner, ranges.size]]
        if cached
          @total += cached
          cached
        else
          winners_count = combinations(path + [winner], ranges[1..])

          @steps_cache[[winner, ranges.size]] = winners_count
        end
      end.sum
    end

    def possible_positions(condition) # rubocop:disable Metrics/CyclomaticComplexity
      chars.each_cons(condition).with_index.with_object([]) do |(slice, index), poss|
        all_filled = slice.all? { |x| ['#', '?'].include?(x) }
        left_neighbor_ok = index - 1 >= 0 ? chars[index - 1] != '#' : true
        right_neighbor_ok = index + condition < chars.size ? chars[index + condition] != '#' : true
        poss << (index..(index + condition - 1)) if all_filled && left_neighbor_ok && right_neighbor_ok
      end
    end
  end
end
