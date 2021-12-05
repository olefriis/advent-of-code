lines = File.readlines('input')

Coord = Struct.new(:x, :y)

segments = lines.map do |line|
  p1, p2 = line.split(' -> ')
  x1, y1 = p1.split(',').map(&:to_i)
  x2, y2 = p2.split(',').map(&:to_i)
  [Coord.new(x1, y1), Coord.new(x2, y2)]
end.select do |segment|
  segment[0].x == segment[1].x || segment[0].y == segment[1].y
end

area = {}
segments.each do |segment|
  if segment[0].x == segment[1].x
    miny, maxy = [segment[0].y, segment[1].y].minmax
    (miny..maxy).each do |y|
      x = segment[0].x
      p = Coord.new(x, y)
      area[p] = (area[p] || 0) + 1
    end
  else
    minx, maxx = [segment[0].x, segment[1].x].minmax
    (minx..maxx).each do |x|
      y = segment[0].y
      p = Coord.new(x, y)
      area[p] = (area[p] || 0) + 1
    end
  end
end

puts area.filter { |_, v| v > 1 }.length
