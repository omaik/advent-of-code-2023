module Day22
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      cubes = input

      p 'sorting'
      settle(cubes)

      p 'sorted'

      cubes.count do |cube|
        (cubes - [cube]).all? do |c|
          c.z.begin == 1 || (cubes - [cube]).detect { |other| c.blocked?(other) }
        end
      end
    end

    def call2
      cubes = input

      p 'sorting'
      settle(cubes)

      cubes.map.with_index do |cube, i|
        p [cube, i]
        settle((cubes - [cube]).map(&:clone)).size
      end.sum
    end

    def input
      @input ||= Input.call(@sample)
    end

    def settle(cubes)
      moved_list = Set.new
      loop do
        moved = false
        cubes.sort_by { |x|  x.z.end }.each do |cube|
          next if cube.z.begin == 1

          max_z = cubes.select do |other|
                    cube.intersects?(other) && other.z.end < cube.z.begin
                  end.max_by { |x| x.z.end }&.z || (0..0)

          diff = cube.z.begin - (max_z.end + 1)

          next if diff <= 0

          # p cube.z
          moved_list << cube
          cube.move_down(diff)
          moved = true
        end

        break unless moved
      end

      moved_list
    end
  end
end
