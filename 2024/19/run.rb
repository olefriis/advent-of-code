towels, designs = File.read('19/input').split("\n\n")

towels = towels.strip.split(', ')
towel_regex = /^((#{towels.join(')|(')}))*$/

designs = designs.lines.map(&:strip)

def possibilities(design, towels, acc = {})
    return 1 if design.empty?
    existing_value = acc[design]
    return existing_value if existing_value

    result = 0
    towels.each do |towel|
        if design.start_with?(towel)
            new_design = design[(towel.length)..]
            new_possibilities = possibilities(new_design, towels, acc)
            result += new_possibilities
        end
    end
    acc[design] = result
    result
end

match = 0
part_1, part_2 = 0, 0
designs.each do |design|
    part_1 += 1 if towel_regex.match(design)
    part_2 += possibilities(design, towels)
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
