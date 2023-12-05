module Day5
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        lines = data(sample).split("\n\n")

        seeds = lines.first.split(':').last.split(' ').map(&:to_i).map do |number|
          Seed.new(number)
        end

        seed_ranges = lines.first.split(':').last.split(' ').map(&:to_i).each_slice(2).map do |initial, offset|
          SeedRange.new(initial, offset)
        end

        stages = lines[1..].map do |line|
          Stage.new(line)
        end

        [seeds, stages, seed_ranges]
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Seed
    attr_reader :path

    def initialize(number)
      @number = number
      @path = [number]
    end
  end

  class SeedRange
    attr_reader :path, :range

    def initialize(initial, offset)
      @range = initial..(initial + offset - 1)
      @path = [[@range]]
    end

    def go_through_stage(ranges)
      path.last.map do |subrange|
        convert_into_ranges(subrange, ranges)
      end.flatten
    end

    def convert_into_ranges(range, ranges, accum = []) # rubocop:disable Metrics/PerceivedComplexity
      beginning_range = ranges.detect do |key, _|
        key.include?(range.begin)
      end

      if beginning_range
        offset = range.begin - beginning_range[0].begin
        if beginning_range[0].include?(range.end)
          accum << ((beginning_range[1].begin + offset)..(beginning_range[1].begin + offset + range.size - 1))
        else
          end_offset = beginning_range[0].end - range.begin

          accum << ((beginning_range[1].begin + offset)..(beginning_range[1].begin + offset + end_offset))

          convert_into_ranges((range.begin + end_offset + 1)..range.end, ranges, accum)
        end
      else
        first_range = ranges.to_a.select { |key, _| range.include?(key.begin) }.min_by { |x, _y| x.begin }

        if first_range
          offset = first_range[0].begin - range.begin

          accum << ((range.begin)..(range.begin + offset - 1))

          convert_into_ranges((range.begin + offset)..range.end, ranges, accum)
        else
          accum << range
        end
      end

      accum
    end
  end

  class Stage
    attr_reader :header, :ranges

    def initialize(input)
      lines = input.split("\n")

      @header = lines.first

      @ranges = lines[1..].map do |line|
        values = line.split(' ').map(&:to_i)

        { values[1]..(values[1] + values[2] - 1) => (values[0]..(values[0] + values[2] - 1)) }
      end.inject(&:merge)
    end

    def map(source)
      matching_range = ranges.detect { |range, _| range.include?(source) }

      return source if matching_range.nil?

      (source - matching_range[0].begin) + matching_range[1].begin
    end
  end
end
