chunks = File.read('13/input').split("\n\n")

def which_side?(v_x, v_y, destination_x, destination_y)
    dot = v_x * -destination_y + v_y * destination_x
    if dot < 0
        # Destination is to the right of the vector - too low
        -1
    elsif dot > 0
        # Destination is the the left of the vector - too high
        1
    else
        0
    end
end

def overshoot_by_multiplying?(a_x, a_y, b_x, b_y, prize_x, prize_y, a_times)
    x, y = a_x * a_times, a_y * a_times

    prize_x -= x
    prize_y -= y
    which_side?(b_x, b_y, prize_x, prize_y)
end

def fits?(a_x, a_y, b_x, b_y, prize_x, prize_y, a_times)
    # Bring those coordinates down!
    prize_x -= a_x * a_times
    prize_y -= a_y * a_times

    b_times = prize_x / b_x
    if prize_x == b_x * b_times && prize_y == b_y * b_times
        #puts "Works with #{a_times} and #{b_times}"
        b_times
    else
        #puts "No workee"
        nil
    end
end

def solve_2(a_x, a_y, b_x, b_y, prize_x, prize_y)
    prize_x += 10000000000000
    prize_y += 10000000000000

    if which_side?(a_x, a_y, b_x, b_y) == 0
        puts "Parallel!"
        exit
    end

    initial_overshoot_left = overshoot_by_multiplying?(a_x, a_y, b_x, b_y, prize_x, prize_y, 0)
    initial_overshoot_right = overshoot_by_multiplying?(a_x, a_y, b_x, b_y, prize_x, prize_y, 10000000000000)
    if initial_overshoot_left == initial_overshoot_right
        puts "Same results"
        return 0
    end
    raise "Huh, left is 0" if initial_overshoot_left == 0
    raise "Huh, right is 0" if initial_overshoot_right == 0

    m = initial_overshoot_left > 0 ? -1 : 1

    left, right = 0, 10000000000000
    solution = nil
    while !solution && right - left > 1
        left_overshoot = m * overshoot_by_multiplying?(a_x, a_y, b_x, b_y, prize_x, prize_y, left)
        right_overshoot = m * overshoot_by_multiplying?(a_x, a_y, b_x, b_y, prize_x, prize_y, right)

        middle = (right - left) / 2 + left
        middle_overshoot = m * overshoot_by_multiplying?(a_x, a_y, b_x, b_y, prize_x, prize_y, middle)

        if middle_overshoot == left_overshoot
            left = middle
        elsif middle_overshoot == right_overshoot
            right = middle
        else
            #puts "Got middle: #{middle} - #{middle_overshoot}"
            solution = middle
        end
    end
    #puts "Solution: #{solution}, left: #{left}, right: #{right}"

    if solution
        a_times = solution
        b_times = fits?(a_x, a_y, b_x, b_y, prize_x, prize_y, a_times)
        return a_times * 3 + b_times if b_times
    elsif fits?(a_x, a_y, b_x, b_y, prize_x, prize_y, left)
        puts "left!"
        a_times = left
        b_times = fits?(a_x, a_y, b_x, b_y, prize_x, prize_y, a_times)
        return a_times * 3 + b_times if b_times
    elsif fits?(a_x, a_y, b_x, b_y, prize_x, prize_y, right)
        puts "right!"
        a_times = right
        b_times = fits?(a_x, a_y, b_x, b_y, prize_x, prize_y, a_times)
        return a_times * 3 + b_times if b_times
    end

    0
end

part_2 = 0
machines = chunks.each_with_index.map do |chunk, i|
    puts "Machine #{i}"
    lines = chunk.lines.map(&:strip)
    lines[0] =~ /Button A: X(.*), Y(.*)/ or raise "Could not parse line"
    a_x, a_y = $1.to_i, $2.to_i
    lines[1] =~ /Button B: X(.*), Y(.*)/ or raise "Could not parse line"
    b_x, b_y = $1.to_i, $2.to_i
    lines[2] =~ /Prize: X=(.*), Y=(.*)/ or raise "Could not parse line"
    prize_x, prize_y = $1.to_i, $2.to_i

    part_2 += solve_2(a_x, a_y, b_x, b_y, prize_x, prize_y)

    [[a_x, a_y], [b_x, b_y], [prize_x, prize_y]]
end

puts part_2
