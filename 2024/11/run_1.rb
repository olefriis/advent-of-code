stones = File.readlines('11/input').first.strip.split

25.times do |i|
    #puts "#{i}: #{stones}"
    stones = stones.flat_map do |stone|
        if stone == '0'
            '1'
        elsif stone.length.even?
            [(stone[0...stone.length / 2]).to_i.to_s, stone[stone.length / 2..].to_i.to_s]
        else
            (stone.to_i * 2024).to_s
        end
    end
end

#p stones
puts stones.count
