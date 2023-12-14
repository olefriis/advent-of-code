lines = File.readlines("14/input").map(&:strip).map(&:chars)

def move_north(lines)
  moved = true
  while moved
    moved = false
    1.upto(lines.length-1) do |y|
      lines[y].each_with_index do |char, x|
        if lines[y][x] == 'O' && lines[y-1][x] == '.'
          lines[y][x] = '.'
          lines[y-1][x] = 'O'
          moved = true
        end
      end
    end
  end
  lines
end

def move_south(lines)
  move_north(lines.reverse).reverse
end

def move_west(lines)
  moved = true
  while moved
    moved = false
    1.upto(lines[0].length-1) do |x|
      lines.each_with_index do |char, y|
        if lines[y][x] == 'O' && lines[y][x-1] == '.'
          lines[y][x] = '.'
          lines[y][x-1] = 'O'
          moved = true
        end
      end
    end
  end
end

def move_east(lines)
  moved = true
  while moved
    moved = false
    0.upto(lines[0].length-2) do |x|
      lines.each_with_index do |char, y|
        if lines[y][x] == 'O' && lines[y][x+1] == '.'
          lines[y][x] = '.'
          lines[y][x+1] = 'O'
          moved = true
        end
      end
    end
  end
end

def load(lines)
  result = 0
  lines.each_with_index do |line, y|
    rocks = line.count { |char| char == 'O' }
    multiplier = lines.length - y
    result += rocks * multiplier
  end
  result
end

def move_all(lines)
  move_north(lines)
  move_west(lines)
  move_south(lines)
  move_east(lines)
end

lines_part_1 = lines.dup
move_north(lines_part_1)
puts "Part 1: #{load(lines_part_1)}"

cache = {}

# Populate our cache
i = 0
cycle_start = 0
while i < 1000000000
  move_all(lines)
  i += 1
  key = lines.map(&:join).join
  cycle_start = cache[key]
  if cycle_start
    puts "Got a previous one: Currently at #{i}, this one is #{cycle_start}"
    break
  else
    cache[key] = i
  end
end

cycle_length = i - cycle_start
bumped_times = (1000000000 - cycle_start) / cycle_length
puts "Can bump #{bumped_times} times to get to #{cycle_start + bumped_times * cycle_length}"
i = cycle_start + bumped_times * cycle_length
while i < 1000000000
  puts i
  move_all(lines)
  key = lines.map(&:join).join
  i += 1
end

puts "Part 2: #{load(lines)}"
