arrangement, moves = File.read('05/input').split("\n\n")

arrangement_lines = arrangement.lines

def initialize_stacks(arrangement_lines)
  number_of_stacks = (arrangement_lines[0].chars.count+1)/4
  stacks = []
  arrangement_lines[0..-2].reverse.each do |move_line|
    number_of_stacks.times do |stack_number|
      crate = move_line[stack_number*4+1]
      if crate != ' '
        stacks[stack_number] ||= []
        stacks[stack_number] << crate
      end
    end
  end
  stacks
end

stacks = initialize_stacks(arrangement_lines)
moves.lines.map(&:strip).each do |move|
  move =~ /move (\d+) from (\d+) to (\d+)/
  number_of_crates, from_stack, to_stack = $1.to_i, $2.to_i, $3.to_i
  number_of_crates.times do
    stacks[to_stack-1] << stacks[from_stack-1].pop
  end
end

puts "Part 1: #{stacks.map {|stack| stack[-1]}.join}"

stacks = initialize_stacks(arrangement_lines)
moves.lines.map(&:strip).each do |move|
  move =~ /move (\d+) from (\d+) to (\d+)/
  number_of_crates, from_stack, to_stack = $1.to_i, $2.to_i, $3.to_i
  stacks[to_stack-1].append(*(stacks[from_stack-1].pop(number_of_crates)))
end

puts "Part 2: #{stacks.map {|stack| stack[-1] || ' '}.join}"
