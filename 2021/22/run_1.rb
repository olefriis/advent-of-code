lines = File.readlines('input').map(&:strip)

area = {}

lines.each do |line|
  onoff, cube = line.split(' ')
  ranges = cube.split(',')
  ranges = ranges
    .map { |r| r.split('=').last }
    .map { |r| r.split('..').map(&:to_i) }
  puts "#{onoff} #{ranges}"

  if ranges[0][1] < -50 || ranges[0][0] > 50 || ranges[1][1] < -50 || ranges[1][0] > 50 || ranges[2][1] < -50 || ranges[2][0] > 50
    puts "Skipping"
    next
  end

  ranges.each do |range|
    range[0] = [-50, range[0]].max
    range[1] = [50, range[1]].min
  end
  puts "-> #{onoff} #{ranges}"

  rangexmin, rangexmax = ranges[0]
  rangeymin, rangeymax = ranges[1]
  rangezmin, rangezmax = ranges[2]
  if onoff == 'on'
    rangexmin.upto(rangexmax) do |x|
      rangeymin.upto(rangeymax) do |y|
        rangezmin.upto(rangezmax) do |z|
          area[[x, y, z]] = true
        end
      end
    end
  else
    rangexmin.upto(rangexmax) do |x|
      rangeymin.upto(rangeymax) do |y|
        rangezmin.upto(rangezmax) do |z|
          area.delete([x, y, z])
        end
      end
    end
  end
end

puts "We have #{area.keys.count} lights on"
