BAGS = {}

File.readlines('input').map(&:strip).each do |line|
  bag_type, contents = line.split(' bags contain ')
  raise "Weird line: #{line}" unless bag_type && contents
  BAGS[bag_type] = []

  if contents != 'no other bags.'
    contents.strip.gsub('.', '').split(', ').each do |content_type|
      raise "Weird line: '#{line}' - '#{contents}'" unless content_type =~ /^(\d+) (.*) bags?/
      amount, type = $1, $2
      BAGS[bag_type] << type
    end
  end
end

def suitable?(bag, type)
  BAGS[bag].include?(type) || BAGS[bag].select { |b| suitable?(b, type) }.count > 0
end

puts BAGS.keys.select { |b| suitable?(b, 'shiny gold') }.count