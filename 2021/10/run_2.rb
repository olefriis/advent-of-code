lines = File.readlines('input').map(&:strip)

def score(line)
  reverse = { ')' => '(', '}' => '{', ']' => '[', '>' => '<' }
  scores = { '(' => 1, '[' => 2, '{' => 3, '<' => 4 }
  stack = []

  line.split('').each_with_index do |char|
    if ['(', '{', '[', '<'].include?(char)
      stack.push(char)
    elsif [')', '}', ']', '>'].include?(char)
      return 0 if stack.last != reverse[char]
      stack.pop
    end
  end

  # Not done
  stack.reverse.reduce(0) { |score, char| score *= 5; score += scores[char] }
end

relevant_scores = lines.map { |line| score(line) }.filter { |score| score > 0 }
puts relevant_scores.sort[relevant_scores.length / 2]