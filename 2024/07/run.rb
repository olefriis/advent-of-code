lines = File.readlines('07/input').map(&:strip)

def check(part_2, result, current_result, remainings)
    if remainings.empty?
        return result == current_result
    end

    next_number, remainings = remainings[0], remainings[1..]
    check(part_2, result, current_result + next_number, remainings) ||
        check(part_2, result, current_result * next_number, remainings) ||
        (part_2 && check(part_2, result, (current_result.to_s + next_number.to_s).to_i, remainings))
end

part_1, part_2 = 0, 0
lines.each do |line|
    result, numbers = line.split(':')
    result = result.to_i
    numbers = numbers.strip.split(' ').map(&:to_i)

    first_result = numbers[0]
    remainings = numbers[1..]
    part_1 += result if check(false, result, first_result, remainings)
    part_2 += result if check(true, result, first_result, remainings)
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
