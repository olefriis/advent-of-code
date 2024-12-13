chunks = File.read('13/input').split("\n\n")

def solve_1(a_x, a_y, b_x, b_y, prize_x, prize_y)
    possibilities = []
    100.times do |a_times|
        100.times do |b_times|
            cost = a_times * 3 + b_times
            x, y = a_x * a_times + b_x * b_times, a_y * a_times + b_y * b_times
            #puts "Trying #{a_times}, #{b_times}: #{x},#{y}"

            if x == prize_x && y == prize_y
                possibilities << cost
            end
        end
    end
    #puts "Possibilities: #{possibilities}"
    possibilities.min || 0
end

part_1 = 0
machines = chunks.each_with_index.map do |chunk, i|
    puts "Machine #{i}"
    lines = chunk.lines.map(&:strip)
    lines[0] =~ /Button A: X(.*), Y(.*)/ or raise "Could not parse line"
    a_x, a_y = $1.to_i, $2.to_i
    lines[1] =~ /Button B: X(.*), Y(.*)/ or raise "Could not parse line"
    b_x, b_y = $1.to_i, $2.to_i
    lines[2] =~ /Prize: X=(.*), Y=(.*)/ or raise "Could not parse line"
    prize_x, prize_y = $1.to_i, $2.to_i

    part_1 += solve_1(a_x, a_y, b_x, b_y, prize_x, prize_y)

    [[a_x, a_y], [b_x, b_y], [prize_x, prize_y]]
end

puts part_1
