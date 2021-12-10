lines = File.readlines('input').map(&:strip)

def score(line)
  stack = []
  reverse = { ')' => '(', '}' => '{', ']' => '[', '>' => '<' }
  scores = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }

  line.split('').each do |char|
    if ['(', '{', '[', '<'].include?(char)
      stack.push(char)
    elsif [')', '}', ']', '>'].include?(char)
      return scores[char] if stack.last != reverse[char]
      stack.pop
    end
  end

  0
end

result = lines.map { |line| score(line) }.sum

puts result