heights = File.readlines('08/input').map(&:strip).map(&:chars).map {|line| line.map(&:to_i)}

visible_trees = 0
0.upto(heights.length - 1) do |y|
  0.upto(heights[y].length - 1) do |x|
    tree = heights[y][x]
    left = heights[y][0...x].max || -1
    right = heights[y][x + 1..-1].max || -1
    up = heights[0...y].map {|row| row[x]}.max || -1
    down = heights[y + 1..-1].map {|row| row[x]}.max || -1
    visible_trees += 1 if left < tree || right < tree || up < tree || down < tree
  end
end
puts "Part 1: #{visible_trees}"

def visible(tree, trees)
  result = 0
  trees.each do |t|
    result += 1
    return result if t >= tree
  end
  result
end

highest_scenic_score = 0
0.upto(heights.length - 1) do |y|
  0.upto(heights[y].length - 1) do |x|
    tree = heights[y][x]
    trees_left = heights[y][0...x].reverse
    trees_right = heights[y][x + 1..-1]
    trees_up = heights[0...y].map {|row| row[x]}.reverse
    trees_down = heights[y + 1..-1].map {|row| row[x]}

    visible_trees_left = visible(tree, trees_left)
    visible_trees_right = visible(tree, trees_right)
    visible_trees_up = visible(tree, trees_up)
    visible_trees_down = visible(tree, trees_down)
    scenic_score = visible_trees_left * visible_trees_right * visible_trees_up * visible_trees_down
    highest_scenic_score = [highest_scenic_score, scenic_score].max
  end
end
puts "Part 2: #{highest_scenic_score}"
