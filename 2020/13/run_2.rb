lines = File.readlines('input').map(&:strip)
buses = lines[1].split(',').each_with_index.to_a.select {|b, i| b != 'x' }.map {|b, i| [b.to_i, i]}

p buses

# All we know at the beginning is that the solution is somewhere between 0 and 1909273434898297
# (19*41*37*787*13*23*29*571*17).
# Turns out, it's about a fourth of the way: 500033211739354
# Brute-forcing will not work...

start_time = 0
loop do
  puts "Now at #{start_time}" if start_time % 100000 == 0
  if buses.all? {|bus, offset| (start_time + offset) % bus == 0 }
    puts "Worked at #{start_time}"
    exit
  end
  start_time += 1
end

