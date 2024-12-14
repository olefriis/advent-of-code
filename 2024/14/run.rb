lines = File.readlines('14/input').map(&:strip)

WIDTH=101
HEIGHT=103

part_1 = 0
q1, q2, q3, q4 = 0, 0, 0, 0
middle_x = WIDTH / 2
middle_y = HEIGHT / 2
robots = lines.map do |line|
    line =~ /p=(.*),(.*) v=(.*),(.*)/ or raise "Cannot parse line #{line}"
    s_x, s_y, v_x, v_y = $1.to_i, $2.to_i, $3.to_i, $4.to_i

    ending_x = (s_x + v_x * 100) % WIDTH
    ending_y = (s_y + v_y * 100) % HEIGHT

    if ending_x < middle_x && ending_y < middle_y
        q1 += 1
    elsif ending_x < middle_x && ending_y > middle_y
        q2 += 1
    elsif ending_x > middle_x && ending_y < middle_y
        q3 += 1
    elsif ending_x > middle_x && ending_y > middle_y
        q4 += 1
    end

    [s_x, s_y, v_x, v_y]
end
puts "Part 1: #{q1 * q2 * q3 * q4}"

puts "Finding images that MAY look like a Christmas tree... no guarantee..."
10000.times do |i|
    positions = robots.map { |robot| [(robot[0] + i * robot[2]) % WIDTH, (robot[1] + i * robot[3]) % HEIGHT] }.to_set
    has_line = positions.any? { |x, y| 10.times.all? { |i| positions.include?([x+i, y]) } }

    if has_line
        puts "#{i}"
        HEIGHT.times do |y|
            puts(WIDTH.times.map { |x| positions.include?([x, y]) ? '#' : ' ' }.join)
        end
    end
end
