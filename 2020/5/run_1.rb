seats = File.readlines('input').map(&:strip)

seat_ids = seats.map do |seat|
  seat
    .gsub('B', '1')
    .gsub('F', '0')
    .gsub('R', '1')
    .gsub('L', '0')
    .to_i(2)
end

puts "Biggest seat ID: #{seat_ids.max}"