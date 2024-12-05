order_lines, page_lines = File.read('05/input').split("\n\n")
orders = order_lines.lines.map(&:strip).map { |line| line.split('|') }.to_set
page_lines = page_lines.lines.map(&:strip).map { |line| line.split(',') }

part_1, part_2 = 0, 0
page_lines.each do |line|
    sorted = line.sort do |first_page, last_page|
        if orders.include?([first_page, last_page])
            -1
        elsif orders.include?([last_page, first_page])
            1
        else
            0
        end
    end
    middle = sorted[sorted.count / 2].to_i
    if sorted == line
        part_1 += middle
    else
        part_2 += middle
    end
end
puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
