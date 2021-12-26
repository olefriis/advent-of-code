require 'set'

# Each cube is an array of 3 elements, each containing start and end in either x, y, or z
cubes = Set.new

def overlaps?(range1, range2)
  # Start of first range is before end of second range and
  # end of first range is after start of second range
  range1.first < range2.last && range1.last > range2.first
end

def split_cubes(cubes, new_cube, insert)
  overlapping_cubes = cubes.select do |cube|
    overlaps?(cube[0], new_cube[0]) &&
    overlaps?(cube[1], new_cube[1]) &&
    overlaps?(cube[2], new_cube[2])
  end
  overlapping_cubes.each { |cube| cubes.delete(cube) }

  # Split the old cubes so they don't overlap with the new cube
  overlapping_cubes.each do |cube|
    # Split the cube along the x axis
    if cube[0].first < new_cube[0].first
      cubes << [[cube[0].first, new_cube[0].first], cube[1], cube[2]]
    end
    if cube[0].last > new_cube[0].last
      cubes << [[new_cube[0].last, cube[0].last], cube[1], cube[2]]
    end
    x_range = [[cube[0].first, new_cube[0].first].max, [cube[0].last, new_cube[0].last].min]

    # Split the cube along the y axis
    if cube[1].first < new_cube[1].first
      cubes << [x_range, [cube[1].first, new_cube[1].first], cube[2]]
    end
    if cube[1].last > new_cube[1].last
      cubes << [x_range, [new_cube[1].last, cube[1].last], cube[2]]
    end
    y_range = [[cube[1].first, new_cube[1].first].max, [cube[1].last, new_cube[1].last].min]

    # Split the cube along the z axis
    if cube[2].first < new_cube[2].first
      cubes << [x_range, y_range, [cube[2].first, new_cube[2].first]]
    end
    if cube[2].last > new_cube[2].last
      cubes << [x_range, y_range, [new_cube[2].last, cube[2].last]]
    end
  end

  cubes.add(new_cube) if insert
end

File.readlines('input').map(&:strip).each do |line|
  onoff, cube = line.split(' ')
  ranges = cube.split(',')
  ranges = ranges
    .map { |r| r.split('=').last }
    .map { |r| parts = r.split('..').map(&:to_i); [parts[0], parts[1] + 1] }

  insert = onoff == 'on'
  split_cubes(cubes, ranges, insert)
end

sum = cubes.map { |cube| cube.map { |axis| axis.last - axis.first }.inject(&:*) }.sum
puts sum
