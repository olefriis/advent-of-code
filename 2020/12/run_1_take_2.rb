lines = File.readlines('input').map(&:strip)

Vec = Struct.new(:x, :y) do
  def rotate_left
    Vec.new(-y, x)
  end
end

direction = Vec.new(1, 0)
position = Vec.new(0, 0)

lines.each do |line|
  raise "Weird line" unless line =~ /^(N|S|W|E|R|L|F)(\d+)$/
  command, input = $1, $2.to_i

  case command
  when 'N' then position.y += input
  when 'S' then position.y -= input
  when 'W' then position.x -= input
  when 'E' then position.x += input
  when 'R' then (4-input/90).times { direction = direction.rotate_left }
  when 'L' then (input/90).times { direction = direction.rotate_left }
  when 'F'
    position.x += direction.x * input
    position.y += direction.y * input
  end

  puts "Position: #{position.inspect}"
end

puts "Position: #{position.inspect}"