chunks = File.read('25/input').split("\n\n")

keys, locks = Set.new, Set.new

def count(lock_lines)
    numbers = [0, 0, 0, 0, 0]
    lock_lines[1..].each do |line|
        numbers.each_with_index do |n, i|
            numbers[i] += 1 if line[i] == '#'
        end
    end
    numbers
end

chunks.each do |chunk|
    is_lock = chunk.start_with?('#####')
    lines = chunk.lines.map(&:strip)
    if is_lock
        locks << count(lines)
    else
        keys << count(lines.reverse)
    end
end

part_1 = keys.map do |key|
    locks.count { |lock| lock.zip(key).all? { _1 + _2 <= 5 } }
end.sum

puts "Part 1: #{part_1}"
