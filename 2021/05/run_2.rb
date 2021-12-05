lines = File.readlines('input')

Coord = Struct.new(:x, :y)

segments = lines.map do |line|
  p1, p2 = line.split(' -> ')
  x1, y1 = p1.split(',').map(&:to_i)
  x2, y2 = p2.split(',').map(&:to_i)
  [Coord.new(x1, y1), Coord.new(x2, y2)]
end

def sign(n)
  if n > 0
    1
  elsif n < 0
    -1
  else
    0
  end
end

area = Hash.new(0)
segments.each do |segment|
  inc_x = sign(segment[1].x - segment[0].x)
  inc_y = sign(segment[1].y - segment[0].y)

  p = segment[0]
  loop do
    area[p] += 1
    break if p == segment[1]
    p = Coord.new(p.x + inc_x, p.y + inc_y)
  end
end

puts area.filter { |_, v| v > 1 }.length
