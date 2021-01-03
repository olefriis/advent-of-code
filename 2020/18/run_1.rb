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
    puts "Evaluating. Rest: #{@tokens[@position..-1]}"

    result = nil
    current_operator = nil
    while @position < @tokens.length
      token = @tokens[@position]
      @position += 1
      case token
      when '('
        next_value = evaluate

        if result
          case current_operator
          when '+'
            result += next_value
          when '*'
            result *= next_value
          else
            raise "Weird operator: #{current_operator}"
          end
          current_operator = nil
        else
          result = next_value
        end
      when ')'
        return result
      when '+'
        #puts 'We have a +'
        current_operator = '+'
      when '*'
        #puts 'We have a *'
        current_operator = '*'
      else
        next_value = token.to_i
        #puts "Next value: #{next_value}"

        if result
          case current_operator
          when '+'
            #puts "Adding to #{result}"
            result += next_value
          when '*'
            #puts "Multiplying with #{result}"
            result *= next_value
          else
            raise "Weird operator: #{current_operator}"
          end
          current_operator = nil

        else
          #puts 'No operator, so just grabbing next value'
          result = next_value
        end
      end

      puts "So far: #{result}"
    end

    puts "Result from sub-expression: #{result}"
    result
  end
end

puts lines[5]
puts Evaluator.new(token_lines[5]).evaluate

#token_lines.each {|tokens| puts "#{Evaluator.new(tokens).evaluate}: #{tokens.inspect}"}

resulting_lines = token_lines.each_with_index do |tokens, index|
  puts "Line #{index}"
  Evaluator.new(tokens).evaluate
end


resulting_lines = token_lines.map {|tokens| Evaluator.new(tokens).evaluate}
p resulting_lines

puts resulting_lines.sum