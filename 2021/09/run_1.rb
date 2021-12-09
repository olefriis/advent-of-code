lines = File.readlines('input').map(&:strip).map {|line| line.split('').map(&:to_i)}

risk = 0
(0...lines.length).each do |y|
  (0...lines[y].length).each do |x|
    neighbours = []
    neighbours << lines[y][x-1] if x > 0
    neighbours << lines[y][x+1] if x < lines[y].length - 1
    neighbours << lines[y-1][x] if y > 0
    neighbours << lines[y+1][x] if y < lines.length - 1

    if lines[y][x] < neighbours.min
      risk += lines[y][x] + 1
    end
  end
end

puts risk
