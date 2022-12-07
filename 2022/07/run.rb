lines = File.readlines('07/input').map(&:strip)

AoCDirectory = Struct.new(:name, :parent, :children)
AoCFile = Struct.new(:name, :size)

root_directory = AoCDirectory.new('/', nil, [])
current_directory = root_directory
all_directories = []

lines.each do |line|
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
    directory = AoCDirectory.new(name, current_directory, [])
    current_directory.children << directory
    all_directories << directory
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

part1 = all_directories
  .map { |directory| size_of_directory(directory) }
  .select { |size| size <= 100000 }
  .sum
puts "Part 1: #{part1}"

free_space = 70000000 - size_of_directory(root_directory)
space_needed = 30000000 - free_space
part2 = all_directories
  .map { |directory| size_of_directory(directory) }
  .select { |size| size >= space_needed }
  .min
puts "Part 2: #{part2}"
