lines = File.readlines('input')

Coord = Struct.new(:x, :y)

segments = lines.map do |line|
  p1, p2 = line.split(' -> ')
  x1, y1 = p1.split(',').map(&:to_i)
  x2, y2 = p2.split(',').map(&:to_i)
  [Coord.new(x1, y1), Coord.new(x2, y2)]
end

area = {}
segments.each do |segment|
  diff_x = segment[1].x - segment[0].x
  inc_x = diff_x > 0 ? 1 : (diff_x < 0 ? -1 : 0)
  diff_y = segment[1].y - segment[0].y
  inc_y = diff_y > 0 ? 1 : (diff_y < 0 ? -1 : 0)

  p = segment[0]
  loop do
    area[p] ||= 0
    area[p] += 1
    break if p == segment[1]
    p = Coord.new(p.x + inc_x, p.y + inc_y)
  end
end

result = 0
area.each do |coord, count|
  result += 1 if count > 1
end
puts result