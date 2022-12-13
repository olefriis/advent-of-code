pairs = File.read('13/input').split("\n\n").map do |pair|
  pair.lines.map {|line| eval(line)}
end

def order(left, right)
  if left.is_a?(Integer) && right.is_a?(Integer)
    left <=> right
  elsif left.is_a?(Array) && right.is_a?(Array)
    for i in 0...[left.size, right.size].min
      if order(left[i], right[i]) != 0
        return order(left[i], right[i])
      end
    end
    left.size <=> right.size
  else
    left = [left] if left.is_a?(Integer)
    right = [right] if right.is_a?(Integer)
    order(left, right)
  end
end

part1 = pairs.each_with_index.map do |pair, idx|
  order(*pair) == -1 ? idx + 1 : nil
end.compact.sum
puts "Part 1: #{part1}"

all_packets = []
pairs.each { |pair| all_packets << pair[0] << pair[1] }
divider_1 = [[2]]
divider_2 = [[6]]
all_packets << divider_1 << divider_2

all_packets.sort! { |a, b| order(a, b) }

position_1 = all_packets.index(divider_1) + 1
position_2 = all_packets.index(divider_2) + 1

puts "Part 2: #{position_1 * position_2}"
