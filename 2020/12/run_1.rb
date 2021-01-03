lines = File.readlines('input').map(&:strip)

Vec = Struct.new(:x, :y)

direction = Vec.new(1, 0)
position = Vec.new(0, 0)

for line in lines do
  raise "Weird line" unless line =~ /^([A-Z])(\d+)$/
  command, input = $1, $2.to_i

  case command
  when 'N'
    position.y += input
  when 'S'
    position.y -= input
  when 'W'
    position.x -= input
  when 'E'
    position.x += input
  when 'R'
    direction = case input
    when 0
      direction
    when 90
      Vec.new(direction.y, -direction.x)
    when 180
      Vec.new(-direction.x, -direction.y)
    when 270
      Vec.new(-direction.y, direction.x)
    else
      raise "Weird command: #{line}"
    end
  when 'L'
    direction = case input
    when 0
      direction
    when 90
      Vec.new(-direction.y, direction.x)
    when 180
      Vec.new(-direction.x, -direction.y)
    when 270
      Vec.new(direction.y, -direction.x)
    else
      raise "Weird command: #{line}"
    end
  when 'F'
    position.x += direction.x * input
    position.y += direction.y * input
  else
    raise "Weird line: #{line}"
  end

  puts "Position: #{position.inspect}"

end

puts "Position: #{position.inspect}"