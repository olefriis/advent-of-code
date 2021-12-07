positions = File.read('input').split(',').map(&:to_i)

min, max = positions.minmax

best = max - min
puts "Initial best: #{best}"
best_position = nil
min.upto(max) do |n|
  diff = positions.map { |x| (x - n).abs }.sum
  if !best_position || diff < best
    best = diff
    best_position = n
  end
end

puts positions.map { |x| (x - best_position).abs }.sum
