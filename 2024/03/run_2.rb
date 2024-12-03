line = File.read('03/input').strip

regex = /^mul\((\d{1,3}),(\d{1,3})\)/
result = 0
enabled = true
while line.length > 0
    if line.start_with?('do()')
        enabled = true
    elsif line.start_with?("don't()")
        enabled = false
    elsif line =~ regex && enabled
        v1, v2 = $1.to_i, $2.to_i
        result += v1 * v2
    end
    line = line[1...]
end

puts result
