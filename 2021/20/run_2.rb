lines = File.readlines('input').map(&:strip)

enhancements = lines[0].split('')
image = lines[2..-1].map { |line| line.split('') }

Point = Struct.new(:x, :y)

image_hash = {}
image.each_with_index do |row, y|
  row.each_with_index do |n, x|
    image_hash[Point.new(x, y)] = 1 if n == '#'
  end
end

STARTING_Y = -150
HEIGHT = image.length + 300
STARTING_X = -150
WIDTH = image[0].length + 300

def number_at(pos, image_hash)
  pixels = [
    [-1, -1], [0, -1], [1, -1],
    [-1, 0], [0, 0], [1, 0],
    [-1, 1], [0, 1], [1, 1]
  ].map do |diff|
    p = Point.new(pos.x + diff[0], pos.y + diff[1])
    if p.x < STARTING_X || p.x >= STARTING_X + WIDTH || p.y < STARTING_Y || p.y >= STARTING_Y + HEIGHT
      return image_hash[Point.new(STARTING_X, STARTING_Y)] || 0
    else
      image_hash[p] || 0
    end
  end.join.to_i(2)
end

def light_pixels(image_hash)
  result = 0
  image_hash.each do |pos, value|
    #puts "#{pos.x}, #{pos.y} => #{value}"
    result += 1 if value == 1
  end
  result
end

puts "Width: #{WIDTH}, height: #{HEIGHT}"
puts "Starting x: #{STARTING_X}, starting y: #{STARTING_Y}"

puts light_pixels(image_hash)
default_pixel = 
50.times do |i|
  puts "Iteration #{i}"
  new_image_hash = {}
  (STARTING_Y).upto(STARTING_Y+HEIGHT-1) do |y|
    (STARTING_X).upto(STARTING_X+WIDTH-1) do |x|
      index = number_at(Point.new(x, y), image_hash)
      new_number = enhancements[index] == '#' ? 1 : 0
      new_image_hash[Point.new(x, y)] = 1 if new_number == 1
    end
  end
  image_hash = new_image_hash
  puts "In total, we have #{image_hash.count} pixels lit."
  puts light_pixels(image_hash)
end

# Not 5494
# Not 7823
# Not 5676
# 5268 ? YES!!!
