module Day25
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        @nodes = Hash.new { |h, k| h[k] = Node.new(k) }
        data(sample).split("\n").map do |line|
          main, satellite = line.split(':').map(&:strip)
          satellite = satellite.split(' ').map(&:strip)

          satellite.each do |sat|
            @nodes[main].connections << @nodes[sat]
            @nodes[sat].connections << @nodes[main]
          end
        end

        @nodes
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end

    class Node
      attr_reader :key, :connections

      def initialize(key)
        @key = key
        @connections = []
      end
    end
  end
end
