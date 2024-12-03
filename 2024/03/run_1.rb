line = File.read('03/input').strip

regex = /^mul\((\d{1,3}),(\d{1,3})\)/
result = 0
while line.length > 0
    if line =~ regex
        v1, v2 = $1.to_i, $2.to_i
        puts "multiplying #{$1} and #{$2}"
        result += v1 * v2
    end
    line = line[1...]
end

puts result
