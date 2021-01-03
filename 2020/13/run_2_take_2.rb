require 'pry'

lines = File.readlines('input').map(&:strip)
buses = lines[1].split(',').each_with_index.to_a.select {|b, i| b != 'x' }.map {|b, i| [b.to_i, i]}

p buses

matched = 1
addition = buses[0].first

iterations = 0
start_time = 0
loop do
  puts "Now at #{start_time}"

  matches = []
  busses_matching = buses.map {|bus, offset| (start_time + offset) % bus == 0 }

  number_of_busses_matching = 0
  while busses_matching[number_of_busses_matching]
    number_of_busses_matching += 1
  end

  #binding.pry if number_of_busses_matching >= 2
  while matched < number_of_busses_matching
    addition *= buses[matched].first
    matched += 1
  end

  if busses_matching.all?
    puts "Worked at #{start_time}. Iterations: #{iterations}"
    exit
  end

  start_time += addition
  iterations += 1
end

