chunks = File.read('17/input').split("\n\n")
state, program = chunks[0], chunks[1].split(' ').last

registers = [0, 0, 0]
state = state.lines.map(&:strip)
state.each_with_index do |line, index|
    line =~ /Register .*: (.*)$/ or raise "Strange state line: #{line}"
    registers[index] = $1.to_i
end
instructions = program.split(',').map(&:to_i)

def run(registers, instructions)
    registers, output, pc = registers.clone, [], 0

    while pc < instructions.length
        literal_operand = instructions[pc + 1]
        combo_operand = {
            4 => registers[0],
            5 => registers[1],
            6 => registers[2]
        }[literal_operand] || literal_operand

        case instructions[pc]
        when 0 # adv
            registers[0] = registers[0] >> combo_operand
        when 1 # bxl
            registers[1] = registers[1] ^ literal_operand
        when 2 # bst
            registers[1] = combo_operand % 8
        when 3 # jnz
            pc = literal_operand - 2 if registers[0] != 0
        when 4 # bxc
            registers[1] = registers[1] ^ registers[2]
        when 5 # out
            output << (combo_operand % 8)
        when 6 # bdv
            registers[1] = registers[0] >> combo_operand
        when 7 # cdv
            registers[2] = registers[0] >> combo_operand
        end
        pc += 2
    end

    output
end

puts "Part 1: #{run(registers, instructions).join(',')}"

def to_input(three_bit_chunks)
    result = 0
    three_bit_chunks.each { |n| result = (result << 3) + n }
    result
end

working_inputs = [[]]
instructions.count.times do
    next_working_inputs = []
    working_inputs.each do |working|
        8.times do |i|
            attempt = working + [i]
            registers[0] = to_input(attempt)
            output = run(registers, instructions)

            next_working_inputs << attempt if output == instructions[-attempt.count..]
        end
    end
    working_inputs = next_working_inputs
end

part_2 = working_inputs.select do |working|
    registers[0] = to_input(working)
    run(registers, instructions) == instructions
end.map { |working| to_input(working) }.min

puts "Part 2: #{part_2}"
