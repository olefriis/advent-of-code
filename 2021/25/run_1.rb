require 'pry'

map = File.readlines('input').map(&:strip).map {|line| line.split('')}

def print_map(map)
  puts "\n"
  puts map.map { |row| row.join }.join("\n")
end

i=0
has_moved = true
while has_moved
  has_moved = false

  # East-facing moving first
  new_map = []
  Array.new(map.size, [])
  map.each { new_map << [] }
  map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      source_x = (x-1) % row.length
      desination_x = (x+1) % row.length
      if cell == '.' && map[y][source_x] == '>'
        new_map[y][x] = '>'
        has_moved = true
      elsif cell == '>' && map[y][desination_x] == '.'
        # This one already has moved, so put a . there
        new_map[y][x] = '.'
        has_moved = true
      else
        new_map[y][x] = cell
      end
    end
  end
  map = new_map

  # South-facing now moving
  new_map = []
  map.each { new_map << [] }
  map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      source_y = (y-1) % map.length
      destination_y = (y+1) % map.length
      if cell == '.' && map[source_y][x] == 'v'
        new_map[y][x] = 'v'
        has_moved = true
      elsif cell == 'v' && map[destination_y][x] == '.'
        # This one already has moved, so put a . there
        new_map[y][x] = '.'
        has_moved = true
      else
        new_map[y][x] = cell
      end
    end
  end
  map = new_map

  i += 1
end

print_map(map)

puts "Took #{i} steps"
