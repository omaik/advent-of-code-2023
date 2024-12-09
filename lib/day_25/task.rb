module Day25
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      pairs = input.keys.combination(2).to_a.reject { |x, y| x == y }

      @pathes = {}
      res = pairs.each do |pair|
        p [pair, @pathes.keys.size, pairs.size]
        @pathes[pair.sort] ||= shortest_path(pair)
      end

      counter = Hash.new(0)

      counts = @pathes.values.each do |paths|
        paths.each_cons(2) do |a, b|
          counter[[a, b].sort] += 1
        end
      end

      counter.sort_by { |_k, v| v }.reverse.first(3).each do |k, _v|
        first, last = k
        first_node = input[first]
        last_node = input[last]

        first_node.connections.delete(last_node)
        last_node.connections.delete(first_node)
      end

      matcher = input.keys.first
      connected_count = 1

      @pathes = {}
      binding.pry
      input.keys[1..].each do |node|
        path = shortest_path([matcher, node])
        if path
          connected_count += 1
          @pathes[[matcher, node].sort] = path
        end
      end
      binding.pry
    end

    def call2; end

    def input
      @input ||= Input.call(@sample)
    end

    #"snd", "tlx"] - super long

   # RES 1
# => [[["rtt", "zcj"], 247066],
#  [["gxv", "tpn"], 159068],
#  [["hxq", "txl"], 125303],
#  [["jtl", "zcj"], 81149],
#  [["gxv", "nhb"], 71919],
#  [["zbc", "zcj"], 68847],
#  [["bms", "zcj"], 56568],
#  [["rcl", "tpn"], 56434],
#  [["qkq", "rtt"], 53004],
#  [["lsd", "rtt"], 49099],
#  [["gxv", "sgj"], 48138],
#  [["txl", "xjz"], 48127],
#  [["hxq", "nzp"], 46946],
#
#
#
    def shortest_path(pair)
      start, finish = pair

      # if path = @pathes.detect { |p| p.include?(start) && p.include?(finish) }
      #   start = path.index(start)
      #   finish = path.index(finish)
      #   p "cache used, #{pair.inspect}"

      #   return [[start, finish].min.upto([start, finish].max).map { |i| path[i] }]
      # end
      finishes = []
      point_cache = {}
      queue = [[start]]

      loop do
        break if queue.empty?

        path = queue.shift
        # p path
        # sleep 0.3

        # circle detected
        next if path.size != path.uniq.size
        next if point_cache[path.last] && point_cache[path.last] < path.size

        # break if finishes.any? && finishes.last.size < path.size

        if path.last == finish
          finishes << path
          break
        end

        # if path.size > 2 && (sub_path = @pathes[[path.last(2).first, finish].sort])

        #   p "cache used, #{pair.inspect}"

        #   finishes << (path[...-2] + sub_path)
        #   next
        # end

        node = input[path.last]

        point_cache[node.key] ||= path.size

        node.connections.each do |conn|
          queue << path + [conn.key]
        end
      end

      p [pair, finishes]

      finishes.min_by { |x| x.size }.tap do |path|
        if (path&.size || 0) > 2
          path[..-2].each_with_index do |node, i|
            ((i + 1)..(path.size - 1)).each do |j|
              a = node
              b = path[j]
              @pathes[[a, b].sort] = path[i..j]
            end
          end
        end
      end
    end
  end
end
