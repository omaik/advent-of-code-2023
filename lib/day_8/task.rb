module Day8
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      steps, map = input
      current = 'AAA'

      steps.split('').cycle.with_index(1) do |step, index|
        current = if step == 'L'
                    map[current][0]
                  else
                    map[current][1]
                  end

        return index if current == 'ZZZ'
      end
    end

    def call2
      steps, map = input
      currents = map.keys.select { |x| x.ends_with?('A') }

      currents.map do |current|
        steps.split('').cycle.with_index(1) do |step, index|
          current = if step == 'L'
                      map[current][0]
                    else
                      map[current][1]
                    end

          break index if current.ends_with?('Z')
        end
      end.inject(:lcm)
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
