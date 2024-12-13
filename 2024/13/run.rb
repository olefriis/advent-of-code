chunks = File.read('13/input').split("\n\n")

def solve(a_x, a_y, b_x, b_y, prize_x, prize_y)
    a_slope = a_y.to_f / a_x
    b_times = ((prize_y - a_slope * prize_x) / (b_y - a_slope * b_x)).round
    a_times = ((prize_x - b_times * b_x) / a_x).round

    if a_x * a_times + b_x * b_times == prize_x && a_y * a_times + b_y * b_times == prize_y
        a_times * 3 + b_times
    else
        0
    end
end

part_1, part_2 = 0, 0
machines = chunks.each_with_index.map do |chunk, i|
    lines = chunk.lines.map(&:strip)
    lines[0] =~ /Button A: X(.*), Y(.*)/ or raise "Could not parse line: #{lines[0]}"
    a_x, a_y = $1.to_i, $2.to_i
    lines[1] =~ /Button B: X(.*), Y(.*)/ or raise "Could not parse line: #{lines[1]}"
    b_x, b_y = $1.to_i, $2.to_i
    lines[2] =~ /Prize: X=(.*), Y=(.*)/ or raise "Could not parse line: #{lines[2]}"
    prize_x, prize_y = $1.to_i, $2.to_i

    part_1 += solve(a_x, a_y, b_x, b_y, prize_x, prize_y)
    part_2 += solve(a_x, a_y, b_x, b_y, prize_x + 10000000000000, prize_y + 10000000000000)
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
