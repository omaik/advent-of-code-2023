module Day20
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      # binding.pry

      game_id = 1
      loop do
        input.play(game_id)

        # break if input.signal_trace['a'] > 0

        game_id += 1
      end
    end

    def call2; end

    def input
      @input ||= Input.call(@sample)
    end
  end
end

