require 'pry'
input = File.read('19/input').strip

workflows_input, parts_input = input.split("\n\n")

Rule = Struct.new(:property, :comparison, :value, :destination) do
  def applies?(part)
    part[property].send(comparison, value)
  end

  def split_part(part)
    accepted = []
    rejected = []
    part[property].each do |value|
      if value.send(comparison, self.value)
        accepted << value
      else
        rejected << value
      end
    end
    [part.merge(property => accepted), part.merge(property => rejected)]
  end
end

workflows = {}
workflows_input.split("\n").map do |line|
  line =~ /(.*)\{(.*)\}/ or raise "Bad line: #{line}"
  name, rest = $1, $2
  rules = []
  fallback = nil
  rest.split(',').each do |rule|
    if rule.include?('<') || rule.include?('>')
      rule =~ /^(.*)([<>])(\d+):(.*)$/ or raise "Bad rule: #{rule}"
      property, comparison, value, destination = $1, $2, $3.to_i, $4
      rules << Rule.new(property, comparison, value, destination)
    else
      fallback = rule
    end
  end
  workflows[name] = [rules, fallback]
end

parts = parts_input.split("\n").map do |part|
  part =~ /\{x=(\d+),m=(\d+),a=(\d+),s=(\d+)\}/ or raise "Bad part: #{part}"
  x, m, a, s, = $1.to_i, $2.to_i, $3.to_i, $4.to_i
  {
    "x" => x,
    "m" => m,
    "a" => a,
    "s" => s
  }
end

accepted = []
rejected = []
parts.each do |part|
  workflow = workflows['in']
  loop do
    rules, fallback = workflow
    triggered_rule = rules.find { |rule| rule.applies?(part) }
    destination = triggered_rule&.destination || fallback
    if destination == 'A'
      accepted << part
      break
    elsif destination == 'R'
      rejected << part
      break
    end
    workflow = workflows[destination]
  end
end

part1 = accepted.map { |part| part.values.sum }.sum
puts "Part 1: #{part1}"

workflow_inputs = {}
part = {
  "x" => (1..4000).to_a,
  "m" => (1..4000).to_a,
  "a" => (1..4000).to_a,
  "s" => (1..4000).to_a
}
workflow_inputs['in'] = [part]
workflows['A'] = [[], 'A']
workflows['R'] = [[], 'R']
changed = true
i = 0
while changed
  i += 1
  break if i == 15 # ...because some logic below doesn't leave "changed" alone. Gotta fgure out why.
  changed = false
  workflow_inputs.dup.each do |name, parts|
    rules, fallback = workflows[name]
    parts.each do |part|
      rules.each do |rule|
        accepted, part = rule.split_part(part)

        workflow_inputs[rule.destination] ||= Set.new
        changed ||= !workflow_inputs[rule.destination].include?(accepted)
        workflow_inputs[rule.destination] << accepted
      end

      workflow_inputs[fallback] ||= Set.new
      changed ||= !workflow_inputs[fallback].include?(accepted)
      workflow_inputs[fallback] << part
    end
  end
end

part2 = workflow_inputs['A'].map do |part|
  part.values.map { |v| v.size }.inject(&:*) rescue binding.pry
end.sum

puts "Part 2: #{part2}"