require 'set'
require 'pry'

lines = File.readlines('input').map(&:chomp)

numbers = lines[0].split(',').map(&:to_i)

Board = Struct.new(:numbers, :rows, :columns)

def add_board(boards, board)
  numbers = board.flatten
  rows = board
  columns = board.transpose
  boards << Board.new(numbers, rows, columns)
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
    board.numbers.delete(number)
    board.rows.each do |row|
      row.delete(number)
    end
    board.columns.each do |column|
      column.delete(number)
    end
    if board.rows.any? {|row| row.count == 0} || board.columns.any? {|column| column.count == 0}
      puts board.numbers.sum * number
      exit
    end
  end
end