input = File.read('03/input').strip

part_1, part_2, enabled = 0, 0, true
input.scan(/(do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\))/) do |group|
    if group[0] == 'do()'
        enabled = true
    elsif group[0] == "don't()"
        enabled = false
    else
        v1, v2 = $2.to_i, $3.to_i
        part_1 += v1 * v2
        part_2 += v1 * v2 if enabled
    end
end

puts "1: #{part_1}"
puts "2: #{part_2}"
