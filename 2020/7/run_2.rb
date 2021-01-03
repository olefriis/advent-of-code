BAGS = {}

File.readlines('input').map(&:strip).each do |line|
  bag_type, contents = line.split(' bags contain ')
  raise "Weird line: #{line}" unless bag_type && contents
  BAGS[bag_type] = []

  if contents != 'no other bags.'
    contents.strip.gsub('.', '').split(', ').each do |content_type|
      raise "Weird line: '#{line}' - '#{contents}'" unless content_type =~ /^(\d+) (.*) bags?/
      amount, type = $1.to_i, $2
      BAGS[bag_type] << [amount, type]
    end
  end
end

def number_of_bags_in(bag)
  result = 0
  if BAGS[bag].count > 0
    BAGS[bag].each do |amount, subbag|
      result += amount + amount * number_of_bags_in(subbag)
    end
  end
  result
end

puts number_of_bags_in('shiny gold')