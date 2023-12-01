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

    def call2
      input.map do |line|
        group_match = "\\d|#{WORDS_TO_NUMBERS.keys.join('|')}"
        nums = line.scan(/#{group_match}/)
        arr = [nums.first, nums.last]
        nums = arr.map do |x|
          if WORDS_TO_NUMBERS.keys.include?(x)
            WORDS_TO_NUMBERS[x]
          else
            x&.to_i
          end
        end
        nums[1] = nums[0] if nums[1].nil?
        nums.join.to_i
      end.sum
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
