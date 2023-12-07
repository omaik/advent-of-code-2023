module Day7
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map do |line|
          Hand.new(line)
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Hand
    ORDER = %w[A K Q J T 9 8 7 6 5 4 3 2].reverse.freeze
    ORDER_WITH_JOKER = %w[A K Q T 9 8 7 6 5 4 3 2 J].reverse.freeze

    attr_reader :bid

    def initialize(line)
      @cards, @bid = line.split(' ')
      @bid = @bid.to_i

      @card_groups = @cards.split('').group_by(&:itself).sort_by { |_k, v| v.size }.reverse
    end

    def calculate_score
      first_2_groups_score = @card_groups.first(2).map { |_k, v| v.size }
      type_score = first_2_groups_score.first * 2 + first_2_groups_score.last

      card_scores = @cards.split('').map { |card| ORDER.index(card) }

      [type_score, *card_scores]
    end

    def calculate_joker_score
      jokers_count = @cards.count('J')

      first_2_groups_score = @card_groups.reject { |x| x[0] == 'J' }.first(2).map { |_k, v| v.size }
      type_score = (first_2_groups_score.fetch(0, 0) + jokers_count) * 2 + first_2_groups_score.fetch(1, 0)

      card_scores = @cards.split('').map { |card| ORDER_WITH_JOKER.index(card) }

      [type_score, *card_scores]
    end
  end
end
