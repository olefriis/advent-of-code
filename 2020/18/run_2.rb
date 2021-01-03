lines = File.readlines('input').map(&:strip)

token_lines = lines.map do |line|
  tokens = []
  current_token = ''
  position = 0
  while position < line.length
    case line[position]
    when ' '
      tokens << current_token unless current_token.empty?
      current_token = ''
    when '('
      tokens << '('
    when ')'
      tokens << current_token unless current_token.empty?
      current_token = ''
      tokens << ')'
    when '+'
      tokens << '+'
    when '*'
      tokens << '*'
    when /[0-9]/
      current_token += line[position]
    end
    position += 1
  end
  tokens << current_token unless current_token.empty?

  tokens
end

class Evaluator
  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def evaluate
    flattened = flattened_version
    evaluate_simple_expression(flattened)
  end

  def flattened_version
    result = []
    while @position < @tokens.length
      token = @tokens[@position]
      @position += 1
      case token
      when '('
        result << evaluate
      when ')'
        return result
      when '+'
        result << '+'
      when '*'
        result << '*'
      else
        result << token
      end
    end

    result
  end

  def evaluate_simple_expression(tokens)
    index_of_multiplication = tokens.index('*')
    if index_of_multiplication
      left_side = tokens[0..index_of_multiplication-1]
      right_side = tokens[index_of_multiplication+1..-1]
      return evaluate_simple_expression(left_side) * evaluate_simple_expression(right_side)
    end

    tokens.reject {|token| token == '+'}.map(&:to_i).sum
  end
end

#p Evaluator.new(token_lines[0]).evaluate

p token_lines.map {|tokens| Evaluator.new(tokens).evaluate}.sum
