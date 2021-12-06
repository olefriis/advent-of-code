initial_ages = File.read('input').split(',').map(&:to_i)
groups = Array.new(9, 0)
initial_ages.each {|age| groups[age] += 1}

# Use 256 times for part 2
80.times do
  a = groups.shift
  groups[8] = a
  groups[6] += a
end

puts groups.sum
