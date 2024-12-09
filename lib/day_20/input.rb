module Day20
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        commands = data(sample).split("\n").to_h do |line|
          command = build_command(line)

          [command.key, command]
        end

        Simulation.new(commands)
      end

      def build_command(line)
        id, destination = line.split(' -> ')

        case id
        when /broadcaster/
          Broadcaster.new(id, destination)
        when /%.+/
          FlipFlop.new(id[1..], destination)
        when /&.+/
          Conjuction.new(id[1..], destination)
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Simulation
    attr_reader :signal_trace

    def initialize(commands)
      @commands = commands
      @signal_trace = Hash.new(0)

      prefill_conjuctions
    end

    def prefill_conjuctions
      @commands.select { |_, v| v.is_a?(Conjuction) }.each do |_, v|
        @commands.select { |_, x| x.destinations.include?(v.key) }.each do |k, _|
          v.signal(k, 'low')
        end
      end
    end

    def play(game_id)
      stack = [%w[button broadcaster low]]

      while stack.any?
        command = stack.shift
        # p command


        p [game_id, command] if command[1] == 'ql' && command[2] == 'high'

        @signal_trace[command[2]] += 1
        next if @commands[command[1]].nil?

        new_commands = @commands[command[1]].signal(command[0], command[2])
        stack.concat(new_commands)
      end
    end
  end

  class Broadcaster
    attr_accessor :key, :destinations

    def initialize(key, destination)
      @key = key
      @destinations = destination.split(', ').map(&:strip)
    end

    def signal(_from, s)
      destinations.map { |d| [key, d, s] }
    end
  end

  class FlipFlop
    attr_accessor :key, :destinations

    def initialize(key, destination)
      @key = key
      @destinations = destination.split(', ').map(&:strip)
      @high = false
    end

    def signal(_from, s)
      return [] if s == 'high'

      @high = !@high

      new_s = @high ? 'high' : 'low'

      destinations.map { |d| [key, d, new_s] }
    end
  end

  class Conjuction
    attr_accessor :key, :destinations, :signals

    def initialize(key, destination)
      @key = key

      @destinations = destination.split(', ').map(&:strip)
      @signals = Hash.new { |h, k| h[k] = 'low' }
    end

    def signal(from, s)
      @signals[from] = s

      new_s = @signals.values.all? { |v| v == 'high' } ? 'low' : 'high'

      destinations.map { |d| [key, d, new_s] }
    end
  end
end
