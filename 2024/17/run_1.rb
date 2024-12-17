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
    registers = registers.clone
    output = []
    pc = 0
    while pc < instructions.length
        inst = instructions[pc]
        literal_operand = instructions[pc + 1]
        combo_operand = literal_operand
        if literal_operand == 4
            combo_operand = registers[0]
        elsif literal_operand == 5
            combo_operand = registers[1]
        elsif literal_operand == 6
            combo_operand = registers[2]
        end

        if inst == 0 # adv
            registers[0] = (registers[0] / (2 ** combo_operand)).to_i
        elsif inst == 1 # bxl
            registers[1] = registers[1] ^ literal_operand
        elsif inst == 2 # bst
            registers[1] = combo_operand % 8
        elsif inst == 3 # jnz
            if registers[0] != 0
                pc = literal_operand - 2
            end
        elsif inst == 4 # bxc
            registers[1] = registers[1] ^ registers[2]
        elsif inst == 5 # out
            output << (combo_operand % 8)
        elsif inst == 6 # bdv
            registers[1] = (registers[0] / (2 ** combo_operand)).to_i
        elsif inst == 7 # cdv
            registers[2] = (registers[0] / (2 ** combo_operand)).to_i
        end
        pc += 2
    end
    output
end

puts "Part 1: #{run(registers, instructions).join(',')}"


def to_input(working)
    result = 0
    working.each do |w|
        result *= 8
        result += w
    end
    result
end

def to_input_2(a)
    result = 0
    a.each do |w|
        result *= 2
        result += w
    end
    result
end

working = []
all_working = [[]]

(instructions.count - 1).downto(0) do |index|
    new_all_working = []
    all_working.each do |working|
        working = working.clone
        working << 0
        8.times do |i|
            working[-1] = i
            registers[0] = to_input(working)
            output = run(registers, instructions)
            if output == instructions[(instructions.count - output.count)..]
                new_all_working << working.clone
            end
        end
    end
    all_working = new_all_working
end

part_2 = all_working.select do |working|
    registers[0] = to_input(working)
    output = run(registers, instructions)
    output == instructions
end.map { |working| to_input(working) }.min

puts "Part 2: #{part_2}"
