module Day5
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      seeds, stages = input

      stages.each do |stage|
        seeds.each do |seed|
          new_value = stage.map(seed.path.last)

          seed.path << new_value
        end
      end

      seeds.map { |x| x.path.last }.min
    end

    def call2
      _, stages, seeds = input

      stages.each do |stage|
        seeds.each do |seed|
          seed.path << seed.go_through_stage(stage.ranges)
        end
      end

      seeds.map { |x| x.path.last.map(&:begin) }.flatten.min
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
