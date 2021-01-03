lines = File.readlines('input').map(&:strip)
p lines
wanted_departure = lines[0].to_i
buses = lines[1].split(',').select {|b| b != 'x' }.map(&:to_i)

best_bus = nil
time_to_to = nil
for bus in buses do
  time_to_go_here = bus - (wanted_departure % bus)
  if best_bus == nil
    best_bus = bus
    time_to_go = time_to_go_here
  end

  if time_to_go_here == [time_to_go_here, time_to_go].min
    best_bus = bus
    time_to_go = time_to_go_here
  end
end

puts "Best bus: #{best_bus}. Time to go: #{time_to_go}"