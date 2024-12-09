module Day24
  class Task
    def initialize(sample)
      @sample = sample
    end

    # 11825 - too low
    # 18200 - too low
    # 26315 - too high
    def call1
      range = @sample ? (7..27) : (200_000_000_000_000..400_000_000_000_000)
      input.combination(2).map do |a, b|
        # binding.pry
        x = a.intersection_x(b)

        next if x == Float::INFINITY || x == -Float::INFINITY
        next unless a.in_future?(x) && b.in_future?(x)

        y = a.find_y(x)

        next unless range.include?(x) && range.include?(y)

        [a, b]
      end.compact.size
    end

    # shit, they need to be detected in the same order(if point 1 was first in X, it should be first for all points(Y, Z))
    # try to find point where distance between min max is the smallest
    def call2
      x_y_intersection
    end

    def x_y_intersection
      binding.pry
      smallest_diff = []
      -500.upto(500) do |x|
        -500.upto(500).each do |y|
          copies = input.sample(5).map do |point|
            point.clone.tap do |p|
              p.xx -= x
              p.yy -= y
            end
          end

          accum = []

          res = copies.combination(2).each do |a, b|
            local_x = a.intersection_x(b)

            next if local_x.nan?
            if local_x == Float::INFINITY || local_x == -Float::INFINITY
              # binding.pry if x == 3 && x_dir = -1 && y_dir == 1 && y == 1
              break
            end

            unless a.in_future?(local_x) && b.in_future?(local_x)
              # binding.pry if x == 3 && x_dir = -1 && y_dir == 1 && y == 1
              break
            end

            local_y = a.find_y(local_x)

            accum << [local_x, local_y]

            # binding.pry if x == 139 && y == -93 && accum.size == 2
            if accum.size < 2 || (((accum[-2].first - accum[-1].first).abs < 1) && ((accum[-2].last - accum[-1].last).abs <1))
              next
            end

            binding.pry if x == 139 && y == -93 && accum.size == 2
            if smallest_diff.empty? || smallest_diff.last > (accum[-2].first - accum[-1].first).abs
              smallest_diff = [x, y,
                               (accum[-2].first - accum[-1].first).abs]
            end
            p smallest_diff if rand(10_000) == 3
            break
          end
          binding.pry if x == 139 && y == -93
          # binding.pry if x == 3 && x_dir = -1 && y_dir == 1 && y == 1
          p [x, y] if rand(10_000) == 3
          next unless res
          next if accum.blank?

          binding.pry if res && accum.any?

          1000.times do |z|
            [-1, 1].each do |z_dir|
              copies2 = input.first(5).map do |point|
                point.clone.tap do |p|
                  p.xx -= x
                  p.zz -= (z * z_dir)
                end
              end

              accum2 = []
              res2 = copies2.combination(2).each do |a, b|
                local_x = a.intersection_z(b)

                next if local_x.nan?
                if local_x == Float::INFINITY || local_x == -Float::INFINITY
                  # binding.pry if x == 3 && x_dir = -1 && y_dir == 1 && y == 1
                  next
                end

                break unless a.in_future?(local_x) && b.in_future?(local_x)

                local_z = a.find_z(local_x)

                accum2 << [local_x, local_z]
                next if accum2.size < 2 || (((accum2[-2].first - accum2[-1].first).abs < 1) && ((accum2[-2].last - accum2[-1].last).abs <1))

                break
              end

              binding.pry if res2 && accum2.any?
            end
          end
        end
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
