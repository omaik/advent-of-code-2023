module Day1
  class Task
    WORDS_TO_NUMBERS = {
      'one' => 1,
      'two' => 2,
      'three' => 3,
      'four' => 4,
      'five' => 5,
      'six' => 6,
      'seven' => 7,
      'eight' => 8,
      'nine' => 9
    }.freeze

    def initialize(sample)
      @sample = sample
    end

    def call1
      input.map do |line|
        res = line.scan(/\d/)
        "#{res.first}#{res.last}".to_i
      end.sum
    end

    def call2
      input.sum do |line|
        nums = line.scan(/\d|#{WORDS_TO_NUMBERS.keys.join('|')}/)
        arr = [nums.first, nums.last]
        arr.map do |x|
          WORDS_TO_NUMBERS.keys.include?(x) ? WORDS_TO_NUMBERS[x] : x
        end.join.to_i
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
