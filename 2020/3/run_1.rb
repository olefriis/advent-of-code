lines = File.readlines('input').map(&:strip)
height = lines.length
width = lines.first.length

x, y, trees = 0, 0, 0

while y < height
  trees += 1 if lines[y][x%width] == '#'

  x += 3
  y += 1
end

puts "Encountered #{trees} trees"