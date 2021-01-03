require 'set'
lines = File.readlines('input').map(&:strip)

splitter = lines.index('')
rule_lines, lines_to_check = lines[0..splitter-1], lines[splitter+1..-1]

MAX_LINE_LENGTH = lines_to_check.map(&:length).max

rules = {}
rule_lines.each do |rule_line|
  raise "Weird line: #{rule_line}" unless rule_line =~ /^(\d+): (.*)$/
  rule_number, options = $1, $2
  rules[rule_number] = options
end
rules['8'] = '42 | 42 8'
rules['11'] = '42 31 | 42 11 31'

RULES = rules

def match(s, position, rule_number, depth)
  rule = RULES[rule_number]
  #puts "Rule #{rule_number}, position #{position}: #{rule}"
  if rule.start_with?('"')
    char = rule[1]
    if s[position] == char
      [position + 1]
    else 
      []
    end
  else
    options = rule.split('|')
    options.flat_map do |option|
      position_for_option = position
      rules_for_option = option.split(' ').map(&:strip)
      if rules_for_option.length == 0
        raise "Have no rules for option for rule #{rule}"
      elsif rules_for_option.length == 1
        match(s, position, rules_for_option[0], depth+1)
      elsif rules_for_option.length == 2
        first_matches = match(s, position, rules_for_option[0], depth+1)
        first_matches.flat_map do |position_after_first_match|
          match(s, position_after_first_match, rules_for_option[1], depth+1)
        end
      elsif rules_for_option.length == 3
        first_matches = match(s, position, rules_for_option[0], depth+1)
        return nil unless first_matches
        first_matches.flat_map do |position_after_first_match|
          second_matches = match(s, position_after_first_match, rules_for_option[1], depth+1)
          second_matches.flat_map do |position_after_second_match|
            match(s, position_after_second_match, rules_for_option[2], depth+1)
          end
        end
      else
        raise "Too many options for rule #{rule}"
      end
    end
  end
end

def matches_0(s)
  match(s, 0, '0', 0).include?(s.length)
end

puts lines.count {|line| matches_0(line)} # 325
