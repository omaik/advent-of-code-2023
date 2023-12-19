module Day15
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.sum(&:sum)
    end

    def call2
      boxes = Hash.new { |h, k| h[k] = [] }
      input.each do |command|
        box_id = command.box_id

        index_in_box = boxes[box_id].index { |x| x.label == command.label }
        if command.operation == '-'
          boxes[box_id].delete_at(index_in_box) if index_in_box
        elsif index_in_box
          boxes[box_id][index_in_box] = command
        else
          boxes[box_id] << command
        end
      end
      boxes.sum do |box_id, commands|
        commands.map.with_index(1) do |command, index|
          command.new_value * index * (box_id + 1)
        end.sum
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
