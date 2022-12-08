heights = File.readlines('08/input').map(&:strip).map(&:chars).map {|line| line.map(&:to_i)}

def visible(tree, trees)
  result = 0
  trees.each do |t|
    result += 1
    return result if t >= tree
  end
  result
end

visible_trees = 0
scenic_scores = []
0.upto(heights.length - 1) do |y|
  0.upto(heights[y].length - 1) do |x|
    tree = heights[y][x]

    left = heights[y][0...x].reverse
    right = heights[y][x + 1..-1]
    up = heights[0...y].map {|row| row[x]}.reverse
    down = heights[y + 1..-1].map {|row| row[x]}

    visible_trees += 1 if (left.max || -1) < tree || (right.max || -1) < tree || (up.max || -1) < tree || (down.max || -1) < tree

    visible_left = visible(tree, left)
    visible_right = visible(tree, right)
    visible_up = visible(tree, up)
    visible_down = visible(tree, down)

    scenic_scores << visible_left * visible_right * visible_up * visible_down
  end
end
puts "Part 1: #{visible_trees}"
puts "Part 2: #{scenic_scores.max}"
