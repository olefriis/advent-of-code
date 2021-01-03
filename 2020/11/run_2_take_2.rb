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
  directions = [
    [-1,-1], [0, -1], [1, -1],
    [-1, 0],          [1,  0],
    [-1, 1], [0,  1], [1,  1]
  ]
  directions.map {|dir_x, dir_y| occupied(seats, x, y, dir_x, dir_y)}.sum
end

def new_value(seats, x, y)
  current_seat = seats[y][x]
  return current_seat if current_seat == '.'

  case adjacent_occupied(seats, x, y)
  when 0
    '#'
  when 5..8
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
    new_seats = seats.each_with_index.map {|line, y| line.length.times.map {|x| new_value(seats, x, y)}.join }
    return new_seats if seats == new_seats

    #puts "\n\nIteration: #{iteration}"
    #new_seats.each {|l| puts l}

    seats = new_seats
    iteration += 1
  end
end

puts iterate.each.map {|line| line.count('#')}.sum