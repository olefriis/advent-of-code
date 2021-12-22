lines = File.readlines('input').map(&:strip)

Action = Struct.new(:onoff, :startx, :endx, :starty, :endy, :startz, :endz)

actions = lines.map do |line|
  onoff, cube = line.split(' ')
  ranges = cube.split(',')
  ranges = ranges
    .map { |r| r.split('=').last }
    .map { |r| r.split('..').map(&:to_i) }

  Action.new(onoff, ranges[0][0], ranges[0][1], ranges[1][0], ranges[1][1], ranges[2][0], ranges[2][1])
end

axisx = (actions.map(&:startx) + actions.map {|a| a.endx + 1}).uniq.sort
axisy = (actions.map(&:starty) + actions.map {|a| a.endy + 1}).uniq.sort
axisz = (actions.map(&:startz) + actions.map {|a| a.endz + 1}).uniq.sort

puts "We have a #{axisx.length} x #{axisy.length} x #{axisz.length} 'grid'"

def reverse_index(array)
  array.each_with_index.map { |v, i| [v, i] }.to_h
end

axisx_index = reverse_index(axisx)
axisy_index = reverse_index(axisy)
axisz_index = reverse_index(axisz)

area = []
actions.each do |action|
  puts "Action: #{action}"

  startx, endx = action.startx, action.endx
  starty, endy = action.starty, action.endy
  startz, endz = action.startz, action.endz
  startx_index, endx_index = axisx_index[startx], axisx_index[endx + 1]
  starty_index, endy_index = axisy_index[starty], axisy_index[endy + 1]
  startz_index, endz_index = axisz_index[startz], axisz_index[endz + 1]

  if action.onoff == 'on'
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
