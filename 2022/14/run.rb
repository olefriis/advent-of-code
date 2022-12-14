lines = File.readlines('14/input', chomp: true)

initial_board = {}
lines.each do |line|
  coords = line.split(' -> ').map {|coord| coord.split(',').map(&:to_i)}
  coords.each_cons(2) do |(x1, y1), (x2, y2)|
    min_x, max_x = [x1, x2].minmax
    min_y, max_y = [y1, y2].minmax
    min_x.upto(max_x) do |x|
      min_y.upto(max_y) do |y|
        initial_board[[x, y]] = true
      end
    end
  end
end
MAX_Y = initial_board.keys.map {|key| key[1]}.max

def position_sand(board)
  pos = [500, 0]
  loop do
    return pos if pos[1] > MAX_Y

    down = [pos[0], pos[1] + 1]
    left_down = [pos[0] - 1, pos[1] + 1]
    right_down = [pos[0] + 1, pos[1] + 1]
    if !board[down]
      pos = down
    elsif !board[left_down]
      pos = left_down
    elsif !board[right_down]
      pos = right_down
    else
      return pos
    end
  end
end

units, board = 0, initial_board.dup
loop do
  pos = position_sand(board)
  board[pos] = true
  if pos[1] > MAX_Y
    puts "Part 1: #{units}"
    break
  end
  units += 1
end

units, board = 0, initial_board.dup
loop do
  units += 1
  pos = position_sand(board)
  board[pos] = true
  if pos == [500, 0]
    puts "Part 2: #{units}"
    break
  end
end
