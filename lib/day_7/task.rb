module Day7
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.sort_by(&:calculate_score).each.with_index(1).map do |hand, index|
        hand.bid * index
      end.sum
    end

    def call2
      input.sort_by(&:calculate_joker_score).each.with_index(1).map do |hand, index|
        hand.bid * index
      end.sum
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
