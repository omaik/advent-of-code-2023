module Day12
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.sum(&:parse)
    end

    def call2
      Parallel.map(input, in_processes: 4, &:cloned_parse).sum
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
