require 'set'
lines = File.readlines('input').map(&:strip)

Position = Struct.new(:x, :y)
flipped_tiles = Set.new
lines.each do |line|
  position = Position.new(0, 0)
  while line.length > 0
    puts line
    if line.start_with?('ne')
      position.x += 1
      position.y -= 1
      line[0...2] = ''
    elsif line.start_with?('nw')
      position.y -= 1
      line[0...2] = ''
    elsif line.start_with?('se')
      position.y += 1
      line[0...2] = ''
    elsif line.start_with?('sw')
      position.y += 1
      position.x -= 1
      line[0...2] = ''
    elsif line.start_with?('e')
      position.x += 1
      line[0...1] = ''
    elsif line.start_with?('w')
      position.x -= 1
      line[0...1] = ''
    else
      raise "Weird line: #{line}"
    end
    p position
  end


  p = [position.x, position.y]
  if flipped_tiles.include?(p)
    flipped_tiles.delete(p)
  else
    flipped_tiles.add(p)
  end
end

100.times do
end

p flipped_tiles
puts flipped_tiles.count
