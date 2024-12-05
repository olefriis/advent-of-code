require 'pry'
order_lines, page_lines = File.read('05/input').split("\n\n")
order_lines = order_lines.lines.map(&:strip)
page_lines = page_lines.lines.map(&:strip)

orders = {}
order_lines.each do |line|
    a, b = line.split('|')
    orders[a] ||= []
    orders[a] << b
end

part_1 = 0
incorrectly_ordered = []
page_lines.each do |line|
    pages = line.split(',')
    invalid = (1).upto(pages.count-1).any? do |i|
        here = pages[i]
        must_be_after = orders[here] || []
        before = pages[0...i]
        (before & must_be_after).any?
    end
    if invalid
        incorrectly_ordered << pages
    else
        part_1 += pages[pages.count / 2].to_i
    end
end
puts "Part 1: #{part_1}"

part_2 = 0
incorrectly_ordered.each do |line|
    sorted = line.sort do |first_page, last_page|
        if (orders[first_page] || []).include?(last_page)
            -1
        elsif (orders[last_page] || []).include?(first_page)
            1
        else
            0
        end
    end
    part_2 += sorted[sorted.count / 2].to_i
end
puts "Part 2: #{part_2}"

# Wrong: 5891

