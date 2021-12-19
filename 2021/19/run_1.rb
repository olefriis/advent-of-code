require 'set'

lines = File.readlines('input').map(&:strip)

Scanner = Struct.new(:name, :points)
# Is x, y, z positive or negative?
Rotation = Struct.new(:x, :y, :z) # Do we negate x, y, or z?
Orientation = Struct.new(:x, :y, :z) # Which order do we use the axes?
ScannerTransformation = Struct.new(:rotation, :orientation, :translation)

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

def overlapping_points(scanner1, scanner2)
  # For each of scanner1's points, try out all rotations of scanner2 and all possible rotations
  max_overlapping_points = []
  max_overlapping_points_transformation = nil
  ALL_ROTATIONS.each do |rotation|
    ALL_ORIENTATIONS.each do |orientation|
      scanner1.points.each do |point1|
        scanner2.points.each do |point2|
          p2_oriented_and_rotated = orient_and_rotate(point2, orientation, rotation)
          # Find a translation that brings the transformed point2 back to point1
          translation = [point1[0] - p2_oriented_and_rotated[0], point1[1] - p2_oriented_and_rotated[1], point1[2] - p2_oriented_and_rotated[2]]

          # Now see how many of scanner2's points match the translation
          scanner2_points_mapped_to_scanner1 = scanner2.points.map do |p|
            oriented_and_rotated = orient_and_rotate(p, orientation, rotation)
            translate(oriented_and_rotated, translation)
          end
          overlapping_points = (scanner2_points_mapped_to_scanner1 & scanner1.points)

          if overlapping_points.length > max_overlapping_points.length
            max_overlapping_points = overlapping_points
            max_overlapping_points_transformation = ScannerTransformation.new(rotation, orientation, translation)
          end
        end
      end
    end
  end

  [max_overlapping_points_transformation, max_overlapping_points]
end

p scanners.map(&:name)
#p scanners.map {|s| s.points.length}

transformation, overlapping_points = overlapping_points(scanners[1], scanners[4])
puts "Overlapping 1-4: #{overlapping_points.length}"
#exit 0


known_scanners = Set.new
known_scanners << '--- scanner 0 ---'

# First, find another scanner that overlaps with the first one
# This is so we can use the first scanner as a reference
other_overlapping_scanners = scanners[1..-1].find do |other_scanner|
  transformation, overlapping_points = overlapping_points(scanners[0], other_scanner)
  if overlapping_points.length >= 12
    puts "Scanner 0 overlaps with scanner #{other_scanner.name} with #{overlapping_points.count} points"
    puts "Transformation: #{transformation}"
    puts "Points before transformation #{other_scanner.points.length} #{other_scanner.points}"
    transform_scanner(other_scanner, transformation)
    puts "Points after transformation #{other_scanner.points.length} #{other_scanner.points}"
    puts "Scanner #{other_scanner.name} points (#{other_scanner.points.length}): #{other_scanner.points}"
    known_scanners << other_scanner.name
  end
end

while known_scanners.length < scanners.length
  puts "Trying new matches"
  known_scanners.dup.each do |scanner1_name|
    scanner1 = scanners.find { |s| s.name == scanner1_name }
    scanners.each do |scanner2|
      if known_scanners.include?(scanner2.name)
        puts "#{scanner1.name} already knows #{scanner2.name}"
        next
      end
      puts "Trying #{scanner1.name} and #{scanner2.name}"
      transformation, overlapping_points = overlapping_points(scanner1, scanner2)
      if overlapping_points.length >= 12
        puts "Scanner #{scanner1.name} overlaps with scanner #{scanner2.name} with #{overlapping_points.count} points"
        transform_scanner(scanner2, transformation)
        known_scanners << scanner2.name
      end
    end
  end
end

all_points = Set.new
scanners.each do |scanner|
  scanner.points.each {|p| all_points << p}
end

puts "We have a total of #{all_points.length} points"
exit 0

transformation, overlapping_points = overlapping_points(scanners[0], scanners[1])
p overlapping_points.length
p overlapping_points
p transformation
