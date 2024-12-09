module Day19
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        rules, input = data(sample).split("\n\n").map(&:strip)

        rules = rules.split("\n").to_h do |rule|
          rule = Rule.new(rule)

          [rule.key, rule]
        end

        input = input.split("\n").map do |line|
          Part.new(line)
        end

        [rules, input]
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Rule
    attr_reader :key, :conditions, :default

    def initialize(rule)
      @key, @conditions = rule.match(/(\w+)\{(.+)\}/).captures

      @conditions = @conditions.split(',').map do |condition|
        Condition.new(condition)
      end
    end

    def evaluate(part)
      @conditions.detect do |condition|
        part.instance_eval(condition.expression)
      end.result
    end

    def split(ranger)
      new_rangers = []
      @conditions.each do |condition|
        unless condition.separator
          new_rangers << [ranger.clone, condition.result]
          next
        end

        key = condition.key

        range = ranger[key]
        last, direction = condition.separator

        if direction == :up
          matched_range = (last..range.end)
          other_range = (range.begin..(last-1))
        else
          matched_range = (range.begin..last)
          other_range = ((last + 1)..range.end)
        end

        matched_ranger = ranger.clone
        matched_ranger[key] = matched_range
        new_rangers << [matched_ranger, condition.result]

        other_ranger = ranger.clone
        other_ranger[key] = other_range
        ranger = other_ranger
      end

      new_rangers
    end
  end

  class Condition
    attr_accessor :expression, :result

    def initialize(raw)
      if raw.include?(':')
        @expression, @result = raw.split(':').map(&:strip)
      else
        @expression = 'true'
        @result = raw
      end
    end

    def separator
      return nil if expression == 'true'

      if expression.include?('>')
        [(expression.match(/(\d+)/)[1].to_i + 1), :up]
      else
        [(expression.match(/(\d+)/)[1].to_i - 1), :down]
      end
    end

    def key
      return nil if expression == 'true'

      expression[0].to_sym
    end
  end

  class Part
    attr_accessor :x, :m, :a, :s

    def initialize(line)
      line = line.gsub('{', '').gsub('}', '')

      line.split(',').each do |var|
        instance_eval("self.#{var}", __FILE__, __LINE__)
      end
    end

    def score
      x + m + a + s
    end
  end
end
