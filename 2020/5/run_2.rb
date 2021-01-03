occupied_seats = File.readlines('input').map(&:strip)

occupied_seat_ids = occupied_seats.map do |seat|
  seat
    .gsub('B', '1')
    .gsub('F', '0')
    .gsub('R', '1')
    .gsub('L', '0')
    .to_i(2)
end

# Not exactly sure which parts to leave out - I don't understand this description:
# Your seat wasn't at the very front or back, though; the seats with IDs +1 and -1 from yours will be in your list.
idle_seat_ids = (32..1023).to_a - occupied_seat_ids

puts "Idle seats: #{idle_seat_ids.sort.inspect}"