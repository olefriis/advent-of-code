require 'pry'

lines = File.readlines('07/input').map(&:strip)

AoCDirectory = Struct.new(:name, :parent, :children)
AoCFile = Struct.new(:name, :size)

root_directory = AoCDirectory.new('/', nil, [])
current_directory = root_directory

lines.each do |line|
  puts line
  if line == '$ cd /'
    current_directory = root_directory
  elsif line == '$ cd ..'
    current_directory = current_directory.parent
  elsif line == '$ ls'
    # Do nothing
  elsif line =~ /\$ cd (.*)/
    directory_name = $1
    current_directory = current_directory.children.find { |child| child.name == directory_name }
    raise "Directory not found: #{directory_name}" unless current_directory
  elsif line =~ /(\d+) (.*)/
    size, name = $1.to_i, $2
    current_directory.children << AoCFile.new(name, size)
  elsif line =~ /dir (.*)/
    name = $1
    raise "Directory already exists: #{name}" if current_directory.children.any? { |child| child.name == name }
    current_directory.children << AoCDirectory.new(name, current_directory, [])
  else
    raise "Unknown command: #{line}"
  end
end

def size_of_directory(directory)
  directory.children.map do |child|
    if child.is_a?(AoCDirectory)
      size_of_directory(child)
    else
      child.size
    end
  end.sum
end

@sizes = 0

def calculate_sizes_of_at_most_100000(directory)
  size = size_of_directory(directory)
  @sizes += size if size <= 100000
  directory.children.each do |child|
    if child.is_a?(AoCDirectory)
      calculate_sizes_of_at_most_100000(child)
    end
  end
end

calculate_sizes_of_at_most_100000(root_directory)
puts "Part 1: #{@sizes}"

free_space = 70000000 - size_of_directory(root_directory)
@space_needed = 30000000 - free_space
puts "Free space: #{free_space}"
puts "Space needed: #{@space_needed}"

@smallest_diff = 70000000
@directory_with_smallest_diff = nil

def find_suiting_directory(directory)
  size = size_of_directory(directory)
  if size >= @space_needed
    diff = size - @space_needed
    if diff < @smallest_diff
      @smallest_diff = diff
      @directory_with_smallest_diff = directory
    end
  end
  directory.children.each do |child|
    if child.is_a?(AoCDirectory)
      find_suiting_directory(child)
    end
  end
end

find_suiting_directory(root_directory)
puts "Directory: #{@directory_with_smallest_diff.name}"

puts "Part 2: #{size_of_directory(@directory_with_smallest_diff)}"
