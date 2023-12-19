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
  { "x" => x, "m" => m, "a" => a, "s" => s }
end

accepted = []
parts.each do |part|
  workflow = workflows['in']
  while workflow
    rules, fallback = workflow
    destination = rules.find { |rule| rule.applies?(part) }&.destination || fallback
    accepted << part if destination == 'A'
    workflow = workflows[destination]
  end
end
part1 = accepted.map { |part| part.values.sum }.sum
puts "Part 1: #{part1}"

workflows['A'] = [[], 'A']
workflows['R'] = [[], 'R']
part = {
  "x" => (1..4000).to_a,
  "m" => (1..4000).to_a,
  "a" => (1..4000).to_a,
  "s" => (1..4000).to_a
}
workflow_inputs = {}
workflows.keys.each { |name| workflow_inputs[name] = Set.new }
workflow_inputs['in'] << part
changed = true
while changed
  changed = false
  workflow_inputs.keys.dup.each do |name|
    rules, fallback = workflows[name]
    parts = workflow_inputs[name]
    parts.each do |part|
      rules.each do |rule|
        accepted, part = rule.split_part(part)

        changed = true if workflow_inputs[rule.destination].add?(accepted)
      end

      changed = true if workflow_inputs[fallback].add?(part)
    end
  end
end

part2 = workflow_inputs['A'].map { |part| part.values.map { |v| v.size }.inject(&:*) }.sum
puts "Part 2: #{part2}"
