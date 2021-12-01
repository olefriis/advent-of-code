lines = File.readlines('input')

previous_depth = nil
larger = 0
for line in lines
  larger += 1 if previous_depth and line.to_i > previous_depth
  previous_depth = line.to_i
end

puts larger
