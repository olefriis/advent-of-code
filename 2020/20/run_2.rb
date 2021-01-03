require 'pry'
image_blocks = File.read('input').split("\n\n")

Image = Struct.new(:id, :borders, :text_lines) do
  def rotate!
    self.borders = self.borders.rotate

    new_text_lines = self.text_lines.count.times.map do |y|
      self.text_lines.count.times.map do |x|
        self.text_lines[x].chars[self.text_lines.count-1-y]
      end.join
    end
    #puts self.text_lines.join("\n")
    #puts ''
    #puts new_text_lines.join("\n")
    #binding.pry
    self.text_lines = new_text_lines
  end

  def flip!
    self.borders = [
      self.borders[0].reverse,
      self.borders[3].reverse,
      self.borders[2].reverse,
      self.borders[1].reverse
    ]

    self.text_lines = self.text_lines.map(&:reverse)
  end

  def flip_and_rotate_to_have_upper!(border)
    self.flip! if self.borders.include?(border.reverse)
    self.rotate! until self.borders[0] == border
  end
  
  def final_image
  end
end

def parse_image(block)
  lines = block.lines.map(&:strip)
  raise "Weird image: #{block}" unless lines.first =~ /^Tile (\d+):$/
  image_id = $1.to_i
  upper_border = lines[1]
  lower_border = lines[-1].reverse
  last_characters = lines[1..-1].map{|line| line.chars.last}.join
  right_border = last_characters
  first_characters = lines[1..-1].map{|line| line.chars.first}.join
  left_border = first_characters.reverse

  Image.new(image_id, [upper_border, right_border, lower_border, left_border], lines[1..-1])
end

images = image_blocks.map {|block| parse_image(block)}
puts "#{images.count} images"

border_to_images = {}
images.each do |image|
  image.borders.each do |border|
    border_to_images[border] ||= []
    border_to_images[border] << image
  end
end

def matching_images(image, border, images)
  matching_images = (images - [image]).select do |other_image|
    matching_borders_for_other_image = 0
    other_image.borders.each do |other_border|
      matching_borders_for_other_image +=1 if other_border == border || other_border.reverse == border
    end
    matching_borders_for_other_image > 0
  end
end

corner_images = images.select do |image|
  matching_borders = 0
  image.borders.each do |border|
    matching_borders += 1 if matching_images(image, border, images).count > 0
  end
  matching_borders == 2
end

def is_upper_left(image, images)
  matching_images(image, image.borders.first, images).empty? &&
    matching_images(image, image.borders.last, images).empty?
end

side_length = Math.sqrt(images.length)
puzzle = []

# First line. Random first tile
first_corner = corner_images.first
# Rotate so the upper and left borders have no matches
puts 'Rotating to upper left'
while !is_upper_left(first_corner, images)
  first_corner.rotate!
end

puts 'Rotated to upper left'

unused_images = images - [first_corner]
current_line = [first_corner]
last_image = first_corner
for i in 1..side_length-1
  # Find the image matching the right side of last tile
  next_images = matching_images(last_image, last_image.borders[1], unused_images)
  raise "More than one match next to #{last_image.id}" unless next_images.length == 1
  next_image = next_images.first

  next_image.flip! if next_image.borders.include?(last_image.borders[1])
  next_image.rotate! until last_image.borders[1] == next_image.borders[3].reverse

  binding.pry if last_image.borders[1] != next_image.borders[3].reverse

  raise "Didn't rotate properly" if last_image.borders[1] != next_image.borders[3].reverse

  current_line << next_image
  last_image = next_image
  unused_images.delete(last_image)
end

tiles = [
  current_line
]

# Remaining rows
for row in 1..side_length-1
  puts "Assembling row #{row}"
  previous_line = tiles[row-1]
  previous_image_on_line = nil
  first_image_on_previous_line = previous_line[0]
  first_image_candidates = matching_images(first_image_on_previous_line, first_image_on_previous_line.borders[2], unused_images)
  raise "#{first_image_candidates.count} possibilities for first image: " if first_image_candidates.count != 1
  first_image = first_image_candidates.first
  first_image.flip_and_rotate_to_have_upper!(first_image_on_previous_line.borders[2].reverse)

  current_line = [first_image]
  unused_images.delete(first_image)
  for column in 1..side_length-1
    image_above = previous_line[column]

    image_candidates = matching_images(image_above, image_above.borders[2], unused_images)
    binding.pry if image_candidates.count != 1
    raise "#{image_candidates.count} possibilities for next image" if image_candidates.count != 1
    next_image = image_candidates.first
    next_image.flip_and_rotate_to_have_upper!(image_above.borders[2].reverse)
    
    current_line << next_image
    unused_images.delete(next_image)
  end
  tiles << current_line
end

puts '---------'
tiles.each {|line| p line.map(&:id)}
puts '---------'


final_image = ''
image_lines = []
tiles.each do |tile_line|
  for i in 1..tile_line.first.text_lines.count-2
    current_line = tile_line.map do |image|
      image_line = image.text_lines[i][1..-2]
    end.join
    image_lines << current_line
  end
end

puts image_lines.join("\n")

p corner_images.map(&:id)

puts corner_images.map(&:id).reduce(1, &:*)
