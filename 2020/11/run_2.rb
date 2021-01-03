def occupied(seats, x, y, dir_x, dir_y)
  loop do
    x += dir_x
    y += dir_y
    return 0 if y<0 || y >= seats.count || x < 0 || x >= seats[y].length
    seat = seats[y][x]
    return 1 if seat == '#'
    return 0 if seat == 'L'
  end
end

def adjacent_occupied(seats, x, y)
  occupied(seats, x, y, -1, -1) + occupied(seats, x, y, 0, -1) + occupied(seats, x, y, 1, -1) +
  occupied(seats, x, y, -1, 0 ) + 0                            + occupied(seats, x, y, 1,  0) +
  occupied(seats, x, y, -1, 1)  + occupied(seats, x, y, 0,  1) + occupied(seats, x, y, 1,  1)
end

def new_value(seats, x, y)
  current_seat = seats[y][x]
  return current_seat if current_seat == '.'

  case adjacent_occupied(seats, x, y)
  when 0
    '#'
  when 5..9
    if current_seat == '#'
      'L'
    else
      current_seat
    end
  else
    current_seat
  end
end

def equal_seats(old, new)
  old.length.times do |y|
    return false unless old[y] == new[y]
  end
  true
end

def iterate
  seats = File.readlines('input').map(&:strip)

  #puts "Start"
  #seats.each {|l| puts l}

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

    return new_seats if equal_seats(seats, new_seats)

    seats = new_seats
    iteration += 1
  end
end

puts iterate.each.map {|line| line.count('#')}.sum