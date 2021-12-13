require 'set'

lines = File.readlines('input').map(&:strip)

separator_line = lines.index { |line| line.empty? }
dot_lines = lines[0...separator_line]
instruction_lines = lines[separator_line + 1..-1]

Pos = Struct.new(:x, :y)
area = Set.new

dot_lines.each do |line|
  x, y = line.split(',').map(&:to_i)
  area.add(Pos.new(x, y))
end

instruction_lines[0..0].each do |line|
  direction, coordinate = line.split('=')
  coordinate = coordinate.to_i
  new_area = Set.new
  case direction
  when 'fold along x'
    area.each { |pos| new_area.add(pos.x >= coordinate ? Pos.new(2 * coordinate - pos.x, pos.y) : pos) }
  when 'fold along y'
    area.each { |pos| new_area.add(pos.y >= coordinate ? Pos.new(pos.x, 2 * coordinate - pos.y) : pos) }
  end
  area = new_area
end

puts area.size
