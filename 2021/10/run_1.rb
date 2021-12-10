lines = File.readlines('input').map(&:strip)
require 'pry'
def score(line)
  puts line
  stack = []
  reverse = {
    ')' => '(',
    '}' => '{',
    ']' => '[',
    '>' => '<'
  }

  scores = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
  }

  line.split('').each do |char|
    if ['(', '{', '[', '<'].include?(char)
      #puts "Pushing #{char}"
      stack.push(char)
    elsif [')', '}', ']', '>'].include?(char)
      #puts "Popping #{char}"
      #puts "Last: #{stack.last}. Reverse: #{reverse[char]}"
      if stack.last != reverse[char]
        #puts 'Wrong #{char}'
        return scores[char]
      end

      #puts 'Match'
      stack.pop
    end
  end
  #puts 'Fine'
  return 0
end

result = lines.map do |line|
  puts score(line)
  score(line)
end

puts result.sum