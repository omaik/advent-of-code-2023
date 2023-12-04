module Day4
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.map(&:points).sum
    end

    def call2
      input.each.with_index.with_object(Hash.new { |h, k| h[k] = 1 }) do |(card, index), copies|
        weight = copies[index]

        ((index + 1)..(card.winning_cards + index)).each do |i|
          copies[i] += weight
        end
      end.values.sum
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
