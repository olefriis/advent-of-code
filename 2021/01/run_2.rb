lines = File.readlines('input')

windows = []
for i in 0...lines.length
  windows << lines[i].to_i + lines[i+1].to_i + lines[i+2].to_i
end

previous_depth = nil
larger = 0
for line in windows
  larger += 1 if previous_depth and line.to_i > previous_depth
  previous_depth = line.to_i
end

puts larger
