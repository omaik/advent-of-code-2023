module Day2
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      limits = { 'green' => 13, 'red' => 12, 'blue' => 14 }
      input.reject do |game|
        game.turns.any? do |turn|
          turn.any? do |color, value|
            value > limits[color]
          end
        end
      end.map(&:id).sum
    end

    def call2
      input.sum do |game|
        game.turns.inject({}) do |memo, turn|
          memo.merge(turn) do |_color, old_value, new_value|
            [old_value, new_value].max
          end
        end.values.inject(:*)
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
