lines = File.readlines('input').map(&:strip)

def simple_evaluate(expression)
  expression.split('*').map {|e| e.split('+').map(&:to_i).sum}.reduce(1, :*)
end

def evaluate(expression)
  # First, get rid of nested expressions, inside-out
  while expression.include?('(')
    expression = expression.gsub(/\([^()]*\)/) do |s|
      expression_without_parentheses = s[1..-2]
      simple_evaluate(expression_without_parentheses)
    end
  end

  # Now we have an expression without parentheses. Just evaluate.
  simple_evaluate(expression)
end

puts lines.map {|line| evaluate(line)}.sum
