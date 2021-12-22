lines = File.readlines('input').map(&:strip)

axisx = []
axisy = []
axisz = []

lines.each do |line|
  onoff, cube = line.split(' ')
  ranges = cube.split(',')
  ranges = ranges
    .map { |r| r.split('=').last }
    .map { |r| r.split('..').map(&:to_i) }
  puts "#{onoff} #{ranges}"

  startx, endx = ranges[0][0], ranges[0][1]
  axisx << startx
  axisx << endx + 1

  starty, endy = ranges[1][0], ranges[1][1]
  axisy << starty
  axisy << endy + 1

  startz, endz = ranges[2][0], ranges[2][1]
  axisz << startz
  axisz << endz + 1
end

axisx.uniq!
axisy.uniq!
axisz.uniq!

axisx.sort!
axisy.sort!
axisz.sort!

puts "We have #{(axisx.count-1) * (axisy.count-1) * (axisz.count-1)} areas"

cubes = {}

linenumber = 1
lines.each do |line|
  puts "Line #{linenumber}"
  linenumber += 1
  onoff, cube = line.split(' ')
  ranges = cube.split(',')
  ranges = ranges
    .map { |r| r.split('=').last }
    .map { |r| r.split('..').map(&:to_i) }
  puts "#{onoff} #{ranges}"

  startx, endx = ranges[0]
  starty, endy = ranges[1]
  startz, endz = ranges[2]
  relevant_x_points = axisx.select { |x| x >= startx && x <= endx }
  relevant_y_points = axisy.select { |y| y >= starty && y <= endy }
  relevant_z_points = axisz.select { |z| z >= startz && z <= endz }
  if onoff == 'on'
    relevant_x_points.each do |x|
      relevant_y_points.each do |y|
        relevant_z_points.each do |z|
          cubes[[x, y, z]] = true
        end
      end
    end
  else
    relevant_x_points.each do |x|
      relevant_y_points.each do |y|
        relevant_z_points.each do |z|
          cubes.delete([x, y, z])
        end
      end
    end
  end
end

puts "Number of cubes: #{cubes.length}"
sum = 0

cubes.each do |start_coordinate, value|
  start_x, start_y, start_z = start_coordinate
  end_x = axisx[axisx.index(start_x) + 1]
  end_y = axisy[axisy.index(start_y) + 1]
  end_z = axisz[axisz.index(start_z) + 1]
  sum += (end_x - start_x) * (end_y - start_y) * (end_z - start_z)
end

puts sum