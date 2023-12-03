module Day3
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      numbers = collect_numbers

      numbers.map(&:first).sum
    end

    def call2
      numbers = collect_numbers

      numbers.select do |x|
        x[1] == '*'
      end.group_by { |x| x[3] }.values.select { |x| x.size == 2 }.map { |y| y.map(&:first).inject(:*) }.sum
    end

    def collect_numbers
      input.each.with_index.with_object([]) do |(line, y), numbers|
        last_x = 0
        while match_data = line[last_x..]&.match(/\d+/)

          start = match_data.begin(0) + last_x
          ending = match_data.end(0) + last_x

          (start...ending).map do |x|
            adjacent(x, y)
          end.flatten(1).each do |adj_x, adj_y|
            next unless input[adj_y] && input[adj_y][adj_x]

            next unless input[adj_y][adj_x] != '.' && !input[adj_y][adj_x].match(/\d/)

            numbers << [match_data[0].to_i, input[adj_y][adj_x], [start..ending, y], [adj_x, adj_y]]
            break
          end

          last_x = ending + 1
        end
      end
    end

    def adjacent(x, y)
      [[x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
       [x - 1, y], [x + 1, y],
       [x - 1, y + 1], [x, y + 1], [x + 1, y + 1]]
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
