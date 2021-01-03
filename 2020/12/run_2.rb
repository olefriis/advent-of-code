lines = File.readlines('input').map(&:strip)

Vec = Struct.new(:x, :y)

direction = Vec.new(1, 0)
waypoint = Vec.new(10, 1)
position = Vec.new(0, 0)

for line in lines do
  raise "Weird line" unless line =~ /^([A-Z])(\d+)$/
  command, input = $1, $2.to_i

  case command
  when 'N'
    waypoint.y += input
  when 'S'
    waypoint.y -= input
  when 'W'
    waypoint.x -= input
  when 'E'
    waypoint.x += input
  when 'R'
    waypoint = case input
    when 0
      waypoint
    when 90
      Vec.new(waypoint.y, -waypoint.x)
    when 180
      Vec.new(-waypoint.x, -waypoint.y)
    when 270
      Vec.new(-waypoint.y, waypoint.x)
    else
      raise "Weird command: #{line}"
    end
  when 'L'
    waypoint = case input
    when 0
      waypoint
    when 90
      Vec.new(-waypoint.y, waypoint.x)
    when 180
      Vec.new(-waypoint.x, -waypoint.y)
    when 270
      Vec.new(waypoint.y, -waypoint.x)
    else
      raise "Weird command: #{line}"
    end
  when 'F'
    position.x += waypoint.x * input
    position.y += waypoint.y * input
  else
    raise "Weird line: #{line}"
  end

  puts "Position: #{position.inspect}"

end

puts "Position: #{position.inspect}"