module Day6
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        time, distance = data(sample).split("\n")

        time = time.split(':').last
        distance = distance.split(':').last
        time2 = time.split(' ').map(&:to_i)
        distance2 = distance.split(' ').map(&:to_i)

        [time2.zip(distance2), [time.gsub(' ', '').to_i, distance.gsub(' ', '').to_i]]
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end
end
