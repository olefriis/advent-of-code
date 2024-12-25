chunks = File.read('25/input').split("\n\n")
keys, locks = [], []
chunks.each do |chunk|
    counts = chunk.lines.map(&:strip).map(&:chars).transpose.map { _1.count('#') }
    (chunk.start_with?('#') ? locks : keys) << counts
end

part_1 = keys.map { |key| locks.count { |lock| lock.zip(key).all? { _1 + _2 <= 7 } } }.sum
puts "Part 1: #{part_1}"
