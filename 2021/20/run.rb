lines = File.read('input').tr('.#', '01').lines.map { |line| line.strip.split('').map(&:to_i) }
enhancements, input_image = lines[0], lines[2..-1]

# Frame it with a ring of initial zeroes
image = [
  *([[0] * (input_image[0].length + 6)]*3),
  *(input_image.map { |row| [0, 0, 0, *row, 0, 0, 0] }),
  *([[0] * (input_image[0].length + 6)]*3),
]

offsets = [
  [-1, -1], [0, -1], [1, -1],
  [-1, 0], [0, 0], [1, 0],
  [-1, 1], [0, 1], [1, 1]
]

50.times do |i|
  height, width = image.length, image[0].length
  image = (height + 4).times.map do |y|
    (width + 4).times.map do |x|
      enhancement_index = offsets.map { |dx, dy| image[(y+dy-2)%height][(x+dx-2)%width] }.join.to_i(2)
      enhancements[enhancement_index]
    end
  end
  puts "#{i+1}: #{image.map(&:sum).sum}" if i == 1 || i == 49
end
