lines = File.readlines('input').map(&:strip)
require 'pry'
def score(line)
  stack = []
  reverse = {
    ')' => '(',
    '}' => '{',
    ']' => '[',
    '>' => '<'
  }

  scores = {
    '(' => 1,
    '[' => 2,
    '{' => 3,
    '<' => 4
  }

  line.split('').each_with_index do |char|
    if ['(', '{', '[', '<'].include?(char)
      #puts "Pushing #{char}"
      stack.push(char)
    elsif [')', '}', ']', '>'].include?(char)
      #puts "Popping #{char}"
      #puts "Last: #{stack.last}. Reverse: #{reverse[char]}"
      if stack.last != reverse[char]
        #puts 'Wrong #{char}'
        # Corrupted
        return 0
      end

      #puts 'Match'
      stack.pop
    end
  end

  # Not done
  score = 0
  stack.reverse.each do |char|
    score *= 5
    score += scores[char]
  end
  puts score
  score
end

result = lines.map do |line|
  score(line)
end.filter {|score| score > 0}
puts result.sort[result.length / 2]