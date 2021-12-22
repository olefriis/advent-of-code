lines = File.readlines('input').map(&:strip)

axisx = []
axisy = []
axisz = []

lines.each do |line|
  onoff, cube = line.split(' ')
  ranges = cube.split(',')
  ranges = ranges
    .map { |r| r.split('=').last }
    .map { |r| r.split('..').map(&:to_i) }
  puts "#{onoff} #{ranges}"

  startx, endx = ranges[0][0], ranges[0][1]
  axisx << startx
  axisx << endx + 1

  starty, endy = ranges[1][0], ranges[1][1]
  axisy << starty
  axisy << endy + 1

  startz, endz = ranges[2][0], ranges[2][1]
  axisz << startz
  axisz << endz + 1
end

axisx.uniq!
axisy.uniq!
axisz.uniq!

axisx.sort!
axisy.sort!
axisz.sort!

puts "We have a #{axisx.length} x #{axisy.length} x #{axisz.length} 'grid'"

def reverse_index(array)
  array.each_with_index.map { |v, i| [v, i] }.to_h
end

axisx_index = reverse_index(axisx)
axisy_index = reverse_index(axisy)
axisz_index = reverse_index(axisz)

area = []

linenumber = 1
lines.each do |line|
  puts "Line #{linenumber}"
  linenumber += 1
  onoff, cube = line.split(' ')
  ranges = cube.split(',')
  ranges = ranges
    .map { |r| r.split('=').last }
    .map { |r| r.split('..').map(&:to_i) }
  puts "#{onoff} #{ranges}"

  startx, endx = ranges[0]
  starty, endy = ranges[1]
  startz, endz = ranges[2]
  startx_index, endx_index = axisx_index[startx], axisx_index[endx + 1]
  starty_index, endy_index = axisy_index[starty], axisy_index[endy + 1]
  startz_index, endz_index = axisz_index[startz], axisz_index[endz + 1]

  if onoff == 'on'
    startx_index.upto(endx_index-1) do |x|
      area[x] ||= []
      starty_index.upto(endy_index-1) do |y|
        area[x][y] ||= []
        startz_index.upto(endz_index-1) do |z|
          area[x][y][z] = true
        end
      end
    end
  else
    startx_index.upto(endx_index-1) do |x|
      next unless area[x]
      starty_index.upto(endy_index-1) do |y|
        next unless area[x][y]
        startz_index.upto(endz_index-1) do |z|
          area[x][y][z] = false
        end
      end
    end
  end
end

sum = 0
area.each_with_index do |x, xi|
  next unless area[xi]
  start_x, end_x = axisx[xi], axisx[xi+1]
  width_x = end_x - start_x
  area[xi].each_with_index do |y, yi|
    next unless area[xi][yi]
    start_y, end_y = axisy[yi], axisy[yi+1]
    width_y = end_y - start_y
    area[xi][yi].each_with_index do |z, zi|
      next unless area[xi][yi][zi]
      start_z, end_z = axisz[zi], axisz[zi+1]
      width_z = end_z - start_z
      sum += width_x * width_y * width_z
    end
  end
end

puts sum
