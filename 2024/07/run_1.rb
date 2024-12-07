require 'pry'
lines = File.readlines('07/input').map(&:strip)

def possible_rest?(result, current_result, remainings)
    if remainings.empty?
        return result == current_result
    end

    next_number = remainings[0]
    remainings_2 = remainings[1..]
    possible_rest?(result, current_result + next_number, remainings_2) || possible_rest?(result, current_result * next_number, remainings_2)
end

def possible?(result, numbers)
    first_result = numbers[0]
    remainings = numbers[1..]
    possible_rest?(result, first_result, remainings)
end

part_1 = 0
lines.each do |line|
    result, numbers = line.split(':')
    result = result.to_i
    numbers = numbers.strip.split(' ').map(&:to_i)
    if possible?(result, numbers)
        #puts "Possible: #{line}"
        part_1 += result
    end
end

puts "Part 1: #{part_1}"
#binding.pry