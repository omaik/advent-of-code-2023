module Day15
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).strip.split(',').map { |chars| Sequence.new(chars) }
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Sequence
    attr_reader :operation, :new_value, :label

    def initialize(chars)
      @chars = chars.split('')
      @label, @operation, @new_value = chars.match(/(\w+)(-|=)(\d)?/).captures

      @new_value = @new_value.to_i
    end

    def sum
      hash_sum(@chars)
    end

    def box_id
      hash_sum(@label.chars)
    end

    def hash_sum(array)
      array.inject(0) do |sum, char|
        ascii = char.ord

        sum += ascii
        sum *= 17

        sum % 256
      end
    end
  end
end
