require 'pry'
lines = File.readlines('12/input').map(&:strip)

# First 30 lines are made up of sections with a number, 3 lines of shapes, and a blank line
original_shapes = 6.times.map do |i|
  shape_lines = lines[(i * 5 + 1)..(i * 5 + 3)]
  shape = shape_lines.map { |line| line.chars }
  shape
end

Problem = Struct.new(:width, :height, :shapes)
# Lines 31 onward are "problems"
problems = lines[30..-1].map do |line|
  parts = line.split(' ')
  dimensions = parts[0][0..-2].split('x').map(&:to_i)
  shape_indices = parts[1..].map(&:to_i)
  Problem.new(dimensions[0], dimensions[1], shape_indices)
end

def all_rotations(shape)
  rotations = []
  current = shape
  4.times do
    rotations << current
    # Rotate 90 degrees clockwise
    current = current.transpose.map(&:reverse)
  end
  rotations
end

def flipped_and_rotated(shape)
  original_rotations = all_rotations(shape)
  flipped_rotations = all_rotations(shape.map(&:reverse))
  (original_rotations + flipped_rotations).uniq
end

def shapes_as_points(shapes)
  shapes.map do |shape|
    points = []
    shape.each_with_index do |line, y|
      line.each_with_index do |char, x|
        points << [x, y] if char == '#'
      end
    end
    points
  end
end

def show_grid(grid, width, height)
  names = 'ABCDEF'
  height.times do |y|
    line = ''
    width.times do |x|
      if grid.key?([x, y])
        line += names[grid[[x, y]]]
      else
        line += '.'
      end
    end
    puts line
  end
end

def solve(width, height, remaining_counts, shapes, grid={})
  if remaining_counts.all? { |count| count == 0 }
    show_grid(grid, width, height)
    return true
  end

  shape_index = remaining_counts.find_index { |count| count > 0 }
  next_shape = shapes[shape_index]

  next_shape.each do |shape|
    # Try placing shape at all possible positions
    shape_width, shape_height = shape.map { |p| p[0] }.max + 1, shape.map { |p| p[1] }.max + 1
    0.upto(width - shape_width).each do |x_offset|
      0.upto(height - shape_height).each do |y_offset|
        translated_shape = shape.map { |p| [p[0] + x_offset, p[1] + y_offset] }
        # Check if it fits
        if translated_shape.all? { |p| p[0] < width && p[1] < height && !grid.key?(p) }
          # Place shape
          translated_shape.each { |p| grid[p] = shape_index }
          remaining_counts[shape_index] -= 1
          return true if solve(width, height, remaining_counts, shapes, grid)
          # Backtrack
          translated_shape.each { |p| grid.delete(p) }
          remaining_counts[shape_index] += 1
        end
      end
    end
  end

  false
end

shape_counts = original_shapes.map do |shape|
  shape.flatten.count('#')
end

p shape_counts

part_1 = problems.map do |problem|
  area = problem.width * problem.height
  total_shape_area = problem.shapes.each_with_index.map { |shape_count, idx| shape_count * shape_counts[idx] }.sum
  total_shape_area <= area
end
p part_1
puts "Part 1: #{part_1.count(true)}"

exit

all_shapes_as_points = original_shapes.map { |shape| shapes_as_points(flipped_and_rotated(shape)) }
part_1 = 0
problems.each_with_index do |problem, index|
  puts "Solving problem #{index + 1}"
  result = solve(problem.width, problem.height, problem.shapes, all_shapes_as_points)
  puts "Result: #{result}"
  part_1 += 1 if result
end
