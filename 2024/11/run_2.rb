stones = File.readlines('11/input').first.strip.split

def iterate(stone)
    if stone == '0'
        ['1']
    elsif stone.length.even?
        [(stone[0...stone.length / 2]).to_i.to_s, stone[stone.length / 2..].to_i.to_s]
    else
        [(stone.to_i * 2024).to_s]
    end
end

stones = stones.tally
75.times do |i|
    next_stones = {}
    stones.each do |stone, count|
        iterate(stone).each do |new_stone|
            next_stones[new_stone] ||= 0
            next_stones[new_stone] += count
        end
    end
    stones = next_stones
end

part_2 = 0
stones.each do |_, count|
    part_2 += count
end
puts part_2
