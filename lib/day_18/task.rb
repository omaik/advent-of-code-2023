module Day18
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      path = [[0, 0]]

      input.each do |instruction|
        path += instruction.move(path.last).to_a
      end

      frame = frame(path)

      count = 0

      @outsiders = []
      @insiders = []

      frame.first.each do |y|
        @inside = nil
        frame.last.each do |x|
          if path.include?([y, x])
            count += 1
            putc '#'
          elsif inside?([y, x], frame, path)
            @insiders << [y, x]
            count += 1
            putc '*'
          else
            @outsiders << [y, x]
            putc '.'
          end
        end

        puts
      end

      count
    end

    def call2; end

    def frame(path)
      [Range.new(*path.map(&:first).minmax), Range.new(*path.map(&:last).minmax)]
    end

    def frame_lines(path, frame)
      @frame_lines ||= frame.first.to_h do |y|
        [y, path.select { |point| point.first == y }.map(&:last).minmax]
      end
    end

    def inside?(point, frame, path)
      return false if point.last < frame_lines(path,
                                               frame)[point.first].first || point.last > frame_lines(path,
                                                                                                     frame)[point.first].last

      # left_distance = point.last - frame.last.begin
      # right_distance = frame.last.end - point.last
      up_distance = point.first - frame.first.begin
      down_distance = frame.first.end - point.first

      min = [up_distance, down_distance].min

      enum = if min == up_distance
               point.first.downto(frame.first.begin - 1)
             elsif min == down_distance
               point.first.upto(frame.first.end + 1)
             end

      walls = 0
      x = point.last

      return true if  @insiders.include?([point.first, x - 1])
      return false if @outsiders.include?([point.first, x - 1])

      enum.each do |y|
        loop do
          unless path.include?([y, x])
            # x += 1
            break
          end

          additive = min == up_distance ? 1 : -1

          if path.include?([y + additive, x + 1])
            walls += 1
            break
          else
            x += 1
          end
        end
      end

      walls.odd?
    end

    def horizontal?(point, path)
      path.include?([point.first, point.last - 1]) || path.include?([point.first, point.last + 1])
    end

    def vertical?(point, path)
      !horizontal?(point, path)
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
