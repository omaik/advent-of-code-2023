module Day6
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.first.map do |time, distance|
        solve_quadratic(time, distance)
      end.inject(:*)
    end

    def call2
      time, distance = input.last

      solve_quadratic(time, distance)
    end

    private

    def solve_quadratic(time, distance)
      discrm = time**2 - (4 * distance)
      x1 = (time - Math.sqrt(discrm)) / 2
      x2 = (time + Math.sqrt(discrm)) / 2

      x1 += 1 if x1 == x1.floor
      x2 -= 1 if x2 == x2.ceil

      x2.floor - x1.ceil + 1
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
