require 'set'
positions = {}
File
  .readlines('18/input', chomp: true)
  .each {|line| positions[line.split(',').map(&:to_i)] = true}

part1 = positions
  .keys
  .map do |x, y, z|
    [
      [-1,0,0], [1,0,0],
      [0,-1,0], [0,1,0],
      [0,0,-1], [0,0,1]
    ].map {|dx, dy, dz| positions[[x + dx, y + dy, z + dz]] ? 0 : 1}.sum
  end.sum
puts "Part 1: #{part1}"

def exterior?(pos, taken)
  return false if taken.include?(pos)

  min_x, max_x = taken.map {|p| p[0]}.minmax
  min_y, max_y = taken.map {|p| p[1]}.minmax
  min_z, max_z = taken.map {|p| p[2]}.minmax

  visited = Set.new(taken)
  visited << pos
  queue = Set.new
  queue << pos
  while queue.any?
    new_queue = Set.new
    queue.each do |x, y, z|
      return true if x < min_x || x > max_x || y < min_y || y > max_y || z < min_z || z > max_z

      [
        [-1,0,0], [1,0,0],
        [0,-1,0], [0,1,0],
        [0,0,-1], [0,0,1]
      ].each do |dx, dy, dz|
        new_pos = [x + dx, y + dy, z + dz]
        unless visited.include?(new_pos)
          new_queue << new_pos
          visited << new_pos
        end
      end
    end
    queue = new_queue
  end

  false
end

part2 = positions
  .keys
  .map do |x, y, z|
    exterior_left = exterior?([x-1, y, z], positions.keys)
    exterior_right = exterior?([x+1, y, z], positions.keys)
    exterior_above = exterior?([x, y-1, z], positions.keys)
    exterior_below = exterior?([x, y+1, z], positions.keys)
    exterior_further_in = exterior?([x, y, z-1], positions.keys)
    exterior_further_out = exterior?([x, y, z+1], positions.keys)
    sum = 0
    sum += 1 if exterior_left
    sum += 1 if exterior_right
    sum += 1 if exterior_above
    sum += 1 if exterior_below
    sum += 1 if exterior_further_in
    sum += 1 if exterior_further_out
    sum
  end.sum
puts "Part 2: #{part2}"
