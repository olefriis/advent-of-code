lines = File.readlines('input').map(&:chomp)

numbers = lines[0].split(',').map(&:to_i)

Board = Struct.new(:numbers, :rows_and_columns) do
  def draw(number)
    numbers.delete(number)
    rows_and_columns.each do |line|
      line.delete(number)
    end
  end

  def bingo?
    rows_and_columns.any?(&:empty?)
  end
end

def add_board(boards, lines)
  numbers = lines.flatten
  rows_and_columns = lines + lines.transpose
  boards << Board.new(numbers, rows_and_columns)
end

boards = []
board = []
board_numbers = lines[2..-1].each do |line|
  if line == ''
    add_board(boards, board)
    board = []
  else
    board << line.strip.split(/ +/).map(&:to_i)
  end
end
add_board(boards, board)

numbers.each do |number|
  puts "Drawing #{number}"

  boards.each do |board|
    board.draw(number)
    if board.bingo?
      puts board.numbers.sum * number
      exit
    end
  end
end