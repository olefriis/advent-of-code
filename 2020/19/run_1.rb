require 'set'
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

def generate_possibilities(rule_number, rules, memory)
  memory[rule_number] ||= begin
    rule = rules[rule_number]
    if rule =~ /^"([ab])"$$/
      [$1]
    else
      alternatives = rule.split('|')
      alternatives.flat_map do |alternative|
        subrules = alternative.split(' ')
        sub_possibilities = subrules.map {|subrule| generate_possibilities(subrule, rules, memory)}
        if subrules.count == 0
          raise "Not expecting 0 subrules for rule #{rule_number}"
        elsif subrules.count == 1
          sub_possibilities[0]
        elsif subrules.count == 2
          #binding.pry
          sub_possibilities[0].flat_map {|p1| sub_possibilities[1].map {|p2| p1 + p2}}
        elsif subrules.count == 3
          sub_possibilities[0].flat_map do |p1|
            sub_possibilities[1].flat_map do |p2|
              sub_possibilities[2].map do |p3|
                p1 + p2 + p3
              end
            end
          end
        else
          raise "Not expecting more than 3 subrules for rule #{rule_number}"
        end
      end
    end
  end
end

possibilities_for_0 = generate_possibilities('0', rules, {})
puts lines.count {|line| possibilities_for_0.include?(line)} # 213
