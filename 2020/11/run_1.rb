require 'pry'

def occupied(seats, x, y)
  (y >= 0 && y < seats.length && x >= 0 && seats[y][x] == '#') ? 1 : 0
end

def adjacent_occupied(seats, x, y)
  occupied(seats, x-1, y-1) + occupied(seats, x, y-1) + occupied(seats, x+1, y-1) +
  occupied(seats, x-1, y  ) + 0                       + occupied(seats, x+1, y  ) +
  occupied(seats, x-1, y+1) + occupied(seats, x, y+1) + occupied(seats, x+1, y+1)
end

def new_value(seats, x, y)
  current_seat = seats[y][x]
  return current_seat if current_seat == '.'

  case adjacent_occupied(seats, x, y)
  when 0
    '#'
  when 4..9
    if current_seat == '#'
      'L'
    else
      current_seat
    end
  else
    current_seat
  end
end

def iterate
  seats = File.readlines('input').map(&:strip)
  iteration = 1
  loop do
    new_seats = []
    seats.length.times do |y|
      old_line = seats[y]

      new_line = ''
      new_seats << new_line
      old_line.length.times do |x|
        new_line << new_value(seats, x, y)
      end
    end

    #puts "\n\nIteration: #{iteration}"
    #new_seats.each {|l| puts l}

    return new_seats if seats == new_seats

    seats = new_seats
    iteration += 1
  end
end

puts iterate.each.map {|line| line.count('#')}.sum