lines = File.readlines('01/input').map(&:strip)

left, right = [], []
lines.each do |line|
    v1, v2 = line.split.map(&:to_i)
    left << v1
    right << v2
end

left.sort!
right.sort!
combined = left.zip(right)

result = combined.sum { |v1, v2| (v1 - v2).abs }
puts result
