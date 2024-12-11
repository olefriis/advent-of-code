stones = File.read('11/input').strip.split.tally

def iterate(stone)
    if stone == '0'
        ['1']
    elsif stone.length.even?
        [(stone[0...stone.length / 2]).to_i.to_s, stone[stone.length / 2..].to_i.to_s]
    else
        [(stone.to_i * 2024).to_s]
    end
end

def solve(stones, iterations)
    iterations.times do |i|
        next_stones = Hash.new(0)
        stones.each do |stone, count|
            iterate(stone).each do |new_stone|
                next_stones[new_stone] += count
            end
        end
        stones = next_stones
    end

    stones.values.sum
end

puts "Part 1: #{solve(stones, 25)}"
puts "Part 2: #{solve(stones, 75)}"
