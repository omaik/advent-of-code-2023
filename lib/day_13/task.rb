module Day13
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.map do |field|
        rows = field[0]
        columns = field[1]
        @found = nil

        rows.each_cons(2).with_index(1) do |(row1, row2), i|
          next unless row1 == row2

          j = 2
          k = 1
          loop do
            if i - j < 0 || i + k >= rows.size
              @found = i * 100
              break
            end

            break if rows[i - j] != rows[i + k]

            k += 1
            j += 1
          end
        end

        next @found if @found

        columns.each_cons(2).with_index(1) do |(column1, column2), i|
          next unless column1 == column2

          j = 2
          k = 1
          loop do
            if i - j < 0 || i + k >= columns.size
              @found = i
              break
            end

            break if columns[i - j] != columns[i + k]

            k += 1
            j += 1
          end
        end

        @found
      end.sum
    end

    def call2
      input.map do |field|
        rows = field[0]
        columns = field[1]
        @found = nil

        rows.each_cons(2).with_index(1) do |(row1, row2), i|
          next unless row1 == row2 || count_difs(row1, row2) == 1

          difs = count_difs(row1, row2)
          j = 2
          k = 1
          loop do
            if i - j < 0 || i + k >= rows.size
              @found = i * 100 if difs == 1
              break
            end

            difs += count_difs(rows[i - j], rows[i + k])

            k += 1
            j += 1
          end
        end

        next @found if @found

        columns.each_cons(2).with_index(1) do |(column1, column2), i|
          next unless column1 == column2 || count_difs(column1, column2) == 1

          difs = count_difs(column1, column2)
          j = 2
          k = 1
          loop do
            if i - j < 0 || i + k >= columns.size
              @found = i if difs == 1
              break
            end

            difs += count_difs(columns[i - j], columns[i + k])

            k += 1
            j += 1
          end
        end

        p @found
      end.sum
    end

    def count_difs(a, b)
      a.each_with_index.count { |x, i| x != b[i] }
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
