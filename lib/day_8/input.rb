module Day8
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        steps, map = data(sample).split("\n\n")

        map = map.split("\n").map do |line|
          match = line.match(/(\w+) = \((\w+), (\w+)\)/)

          { match[1] => [match[2], match[3]] }
        end.inject(&:merge)

        [steps, map]
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end
end
