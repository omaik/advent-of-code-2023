module Day9
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.map do |line|
        conses = build_tree(line)
        conses.map(&:last).sum
      end.sum
    end

    def call2
      input.map do |line|
        conses = build_tree(line)
        conses.reverse.inject(0) do |acc, cons|
          cons.first - acc
        end
      end.sum
    end

    def build_tree(line)
      [line].tap do |conses|
        loop do
          conses << conses.last.each_cons(2).map do |a, b|
            b - a
          end

          break if conses.last.all?(&:zero?)
        end
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
