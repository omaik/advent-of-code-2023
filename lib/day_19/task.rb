module Day19
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      rules, parts = input

      parts.select do |part|
        accepted?(part, rules)
      end.sum(&:score)
    end

    def call2
      rules, parts = input
      rangers = [[{
        x: (1..4000),
        m: (1..4000),
        a: (1..4000),
        s: (1..4000)
      }, 'in']]

      accepted_rangers = []


      loop do
        ranger = rangers.shift


        break if ranger.blank?

        if ranger[1] == 'A'
          accepted_rangers << ranger[0]
          next
        end

        next if ranger[1] == 'R'

        rule = rules[ranger[1]]

        new = rule.split(ranger[0])


        rangers.concat(new)
      end
      accepted_rangers.map { |x| x.transform_values {|v| (v.end - v.begin + 1) }.values.inject(:*) }.sum
    end

    def input
      @input ||= Input.call(@sample)
    end

    def accepted?(part, rules)
      key = 'in'

      loop do
        rule = rules[key]

        result = rule.evaluate(part)

        return true if result == 'A'
        return false if result == 'R'

        key = result
      end
    end
  end
end
