require 'pry'
lines = File.readlines('input').map(&:strip)

splitter = lines.index('')
rule_lines, lines_to_check = lines[0..splitter-1], lines[splitter+1..-1]

rules = {}
rule_lines.each do |rule_line|
  raise "Weird line: #{rule_line}" unless rule_line =~ /^(\d+): (.*)$/
  rule_number, options = $1, $2
  rules[rule_number] = options
end

def generate_regex(rule_number, rules)
  rule = rules[rule_number]

  if rule_number == '8'
    # 8: 42 | 42 8
    "(#{generate_regex('42', rules)})+"
  elsif rule_number == '11'
    # 11: 42 31 | 42 11 31
    "(?<eleven>(#{generate_regex('42', rules)}\\g<eleven>?#{generate_regex('31', rules)}))"
  elsif rule =~ /^"([ab])"$$/
    $1
  else
    '(' + rule.split('|').map do |alternative|
      alternative.split(' ').map {|rule| generate_regex(rule, rules)}.join
    end.join('|') + ')'
  end
end

regex0 = /^#{generate_regex('0', rules)}$/
puts regex0
#binding.pry
puts lines_to_check.count {|line| regex0.match?(line)}
