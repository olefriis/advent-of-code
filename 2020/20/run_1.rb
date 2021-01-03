require 'pry'
image_blocks = File.read('input').split("\n\n")

Image = Struct.new(:id, :borders) do
  def rotate!
    @borders = @borders.rotate
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

  Image.new(image_id, [upper_border, right_border, lower_border, left_border])
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

#binding.pry
corner_images = images.select do |image|
  single_borders = 0
  image.borders.each do |border|
    images_with_matching_borders = (border_to_images[border] || [])
    (border_to_images[border.reverse] || []).each do |reverse_match|
      images_with_matching_borders << reverse_match
    end
    binding.pry unless images_with_matching_borders
    single_borders += 1 if images_with_matching_borders.length == 1
  end
  #binding.pry
  single_borders == 2
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

first_corner = corner_images.first
unused_images = images - [first_corner]


image_tile = [first_corner]



p corner_images.map(&:id)

puts corner_images.map(&:id).reduce(1, &:*)
