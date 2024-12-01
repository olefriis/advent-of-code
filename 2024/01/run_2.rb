lines = File.readlines('01/input').map(&:strip)

left = []
right = Hash.new(0)

lines.each do |line|
    v1, v2 = line.split.map(&:to_i)
    left << v1
    right[v2] += 1
end

result = left.sum { |v1| v1 * right[v1] }
puts result
