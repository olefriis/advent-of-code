require 'pry'

positions = File.read('input').split(',').map(&:to_i)

min, max = positions.minmax

COSTS = Hash.new

def cost(from, to)
  distance = (to - from).abs
  return COSTS[distance] if COSTS[distance]

  a = 1
  COSTS[distance] = distance.times.map do
    a += 1
    a - 1
  end.sum

  COSTS[distance]
end

best = max - min
puts "Initial best: #{best}"
best_position = nil
min.upto(max) do |n|
  diff = positions.map { |x| cost(x, n) }.sum
  if !best_position || diff < best
    best = diff
    best_position = n
  end
end

puts positions.map { |x| cost(x, best_position) }.sum
