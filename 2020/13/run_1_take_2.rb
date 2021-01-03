lines = File.readlines('input').map(&:strip)
wanted_departure = lines[0].to_i
buses = lines[1].split(',').reject {|b| b == 'x'}.map(&:to_i)

# Can we get rid of the repeated calculation?
best_bus = buses.sort_by! {|bus| bus - (wanted_departure % bus)}.first
puts "Best bus: #{best_bus}. Time to go: #{best_bus - (wanted_departure % best_bus)}"
