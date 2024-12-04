lines = File.readlines('04/input').map(&:strip).map(&:chars)

def rotate(lines)
    lines.transpose.map(&:reverse)
end

def xmases(lines)
    result = 0
    0.upto(lines.count-3) do |y|
        line = lines[y]
        0.upto(line.count - 3) do |x|
            if lines[y+1][x+1] == 'A'
                if ((lines[y][x] == 'M' && lines[y+2][x+2] == 'S') || (lines[y][x] == 'S' && lines[y+2][x+2] == 'M')) &&
                    ((lines[y][x+2] == 'M' && lines[y+2][x] == 'S') || (lines[y][x+2] == 'S' && lines[y+2][x] == 'M'))
                    puts "At #{x},#{y}"
                    result += 1
                end
            end
        end
    end
    result
end

puts "Part 2: #{xmases(lines)}"
