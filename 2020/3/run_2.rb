def trees_for_slope(inc_x, inc_y)
  lines = File.readlines('input').map(&:strip)
  height = lines.length
  width = lines.first.length
  
  x, y, trees = 0, 0, 0

  while y < height
    trees += 1 if lines[y][x%width] == '#'

    x += inc_x
    y += inc_y
  end

  puts "Encountered #{trees} trees for slope #{inc_x},#{inc_y}"

  trees
end

trees_1 = trees_for_slope(1, 1)
trees_2 = trees_for_slope(3, 1)
trees_3 = trees_for_slope(5, 1)
trees_4 = trees_for_slope(7, 1)
trees_5 = trees_for_slope(1, 2)

multiplied = trees_1 * trees_2 * trees_3 * trees_4 * trees_5
puts "This multiplies to #{multiplied}"
