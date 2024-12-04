lines = File.readlines('04/input').map(&:strip).map(&:chars)

def rotate(lines)
    lines.transpose.map(&:reverse)
end

def number_of_occurrences_straight(lines)
    result = 0
    0.upto(lines.count-1) do |y|
        line = lines[y]
        0.upto(line.count - 4) do |x|
            if lines[y][x] == 'X' && lines[y][x+1] == 'M' && lines[y][x+2] == 'A' && lines[y][x+3] == 'S'
                result += 1
                #puts "At #{x},#{y}"
            end
        end
    end
    result
end

def number_of_occurrences_45(lines)
    result = 0
    0.upto(lines.count-4) do |y|
        line = lines[y]
        0.upto(line.count - 4) do |x|
            if lines[y][x] == 'X' && lines[y+1][x+1] == 'M' && lines[y+2][x+2] == 'A' && lines[y+3][x+3] == 'S'
                result += 1
                #puts "At #{x},#{y}"
            end
        end
    end
    result 
end

def debug(lines)
    puts lines.map(&:join).join("\n")
end

part_1 = 0
puts "Normal: #{number_of_occurrences_straight(lines)}"
puts "Normal 45: #{number_of_occurrences_45(lines)}"
#debug(lines)
part_1 += number_of_occurrences_straight(lines)
part_1 += number_of_occurrences_45(lines)

lines = rotate(lines)
puts "Rotated once: #{number_of_occurrences_straight(lines)}"
puts "Rotated once 45: #{number_of_occurrences_45(lines)}"
#debug(lines)
part_1 += number_of_occurrences_straight(lines)
part_1 += number_of_occurrences_45(lines)

lines = rotate(lines)
puts "Rotated twice: #{number_of_occurrences_straight(lines)}"
puts "Rotated twice 45: #{number_of_occurrences_45(lines)}"
#debug(lines)
part_1 += number_of_occurrences_straight(lines)
part_1 += number_of_occurrences_45(lines)

lines = rotate(lines)
puts "Rotated thrice: #{number_of_occurrences_straight(lines)}"
puts "Rotated thrice 45: #{number_of_occurrences_45(lines)}"
#debug(lines)
part_1 += number_of_occurrences_straight(lines)
part_1 += number_of_occurrences_45(lines)

puts "1: #{part_1}"
