require 'set'

lines = File.readlines('input').map(&:strip)

Scanner = Struct.new(:name, :points)
Rotation = Struct.new(:x, :y, :z) # Do we negate x, y, or z?
Orientation = Struct.new(:x, :y, :z) # In which order do we use the axes?
ScannerTransformation = Struct.new(:rotation, :orientation, :translation)

# Some of these are probably redundant
ALL_ROTATIONS = [
  Rotation.new(1, 1, 1),
  Rotation.new(1, 1, -1),
  Rotation.new(1, -1, 1),
  Rotation.new(1, -1, -1),
  Rotation.new(-1, 1, 1),
  Rotation.new(-1, 1, -1),
  Rotation.new(-1, -1, 1),
  Rotation.new(-1, -1, -1)
]
# Some of these are probably redundant
ALL_ORIENTATIONS = [
  Orientation.new(0, 1, 2),
  Orientation.new(0, 2, 1),
  Orientation.new(1, 0, 2),
  Orientation.new(1, 2, 0),
  Orientation.new(2, 0, 1),
  Orientation.new(2, 1, 0)
]

scanners = []
scanner = nil
lines.each do |line|
  if !scanner
    scanner = Scanner.new(line, [])
  elsif line.empty?
    scanners << scanner
    scanner = nil
  else
    x, y, z = line.split(',').map(&:to_i)
    scanner.points << [x, y, z]
  end
end
scanners << scanner

def orient_and_rotate(point, orientation, rotation)
  oriented_point = [point[orientation[0]], point[orientation[1]], point[orientation[2]]]
  oriented_and_rotated_point = [rotation[0] * oriented_point[0], rotation[1] * oriented_point[1], rotation[2] * oriented_point[2]]
  oriented_and_rotated_point
end

def translate(point, translation)
  [point[0] + translation[0], point[1] + translation[1], point[2] + translation[2]]
end

def transform_point(point, transformation)
  p = orient_and_rotate(point, transformation.orientation, transformation.rotation)
  translate(p, transformation.translation)
end

def transform_scanner(scanner, transformation)
  scanner.points = scanner.points.map do |point|
    transform_point(point, transformation)
  end
end

def overlapping_points(main_map, scanner)
  ALL_ROTATIONS.each do |rotation|
    ALL_ORIENTATIONS.each do |orientation|
      scanner_points_oriented_and_rotated = scanner.points.map do |point|
        orient_and_rotate(point, orientation, rotation)
      end
      main_map.each do |main_point|
        scanner_points_oriented_and_rotated.each do |point_oriented_and_rotated|
          # Find a translation that brings the transformed point back to main_point
          translation = [main_point[0] - point_oriented_and_rotated[0], main_point[1] - point_oriented_and_rotated[1], main_point[2] - point_oriented_and_rotated[2]]

          # Now see how many of the scanner's transformed points exist in the main map
          scanner_points_mapped_to_main_map = scanner_points_oriented_and_rotated.map { |p| translate(p, translation) }
          overlapping_points = (scanner_points_mapped_to_main_map & main_map)

          if overlapping_points.length >= 12
            return ScannerTransformation.new(rotation, orientation, translation)
          end
        end
      end
    end
  end

  nil
end

known_scanners = Set.new
known_scanners << scanners[0].name
translations = {}
translations[scanners[0].name] = [0, 0, 0]
main_map = scanners[0].points
puts "Main map: #{main_map}"

while known_scanners.length < scanners.length
  puts "Trying new matches. We now have #{known_scanners.length} scanners nailed."
  scanners.filter { |scanner| !known_scanners.include?(scanner.name) }.each do |scanner|
    puts "Trying #{scanner.name}"
    transformation = overlapping_points(main_map, scanner)
    if transformation
      puts "Scanner #{scanner.name} is matching!"
      translations[scanner.name] = transformation.translation
      transform_scanner(scanner, transformation)
      main_map |= scanner.points
      known_scanners << scanner.name
    end
  end
end

puts "We have a total of #{main_map.length} points"

largest_manhattan_distance = 0
scanners.each do |scanner1|
  scanners.each do |scanner2|
    translation1 = translations[scanner1.name]
    translation2 = translations[scanner2.name]
    manhattan_distance = (translation1[0] - translation2[0]).abs + (translation1[1] - translation2[1]).abs + (translation1[2] - translation2[2]).abs
    largest_manhattan_distance = [largest_manhattan_distance, manhattan_distance].max
  end
end

puts "Largest manhattan distance: #{largest_manhattan_distance}"