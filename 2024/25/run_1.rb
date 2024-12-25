chunks = File.read('25/input').split("\n\n")

keys, locks = Set.new, Set.new

def count(lock_lines)
    numbers = [0, 0, 0, 0, 0]
    lock_lines[1..].each do |line|
        numbers[0] += 1 if line[0] == '#'
        numbers[1] += 1 if line[1] == '#'
        numbers[2] += 1 if line[2] == '#'
        numbers[3] += 1 if line[3] == '#'
        numbers[4] += 1 if line[4] == '#'
    end
    numbers
end

require 'pry'
def fit?(lock, key)
    #binding.pry
    lock.zip(key).all? do |a, b|
        a+b <= 5
    end
end

chunks.each do |chunk|
    is_lock = chunk.start_with?('#####')
    lines = chunk.lines.map(&:strip)
    if is_lock
        locks << count(lines)
    else
        lines = lines.reverse 
        keys << count(lines)
    end
end

puts "Keys"
#p keys

puts "Locks"
#p locks

part_1 = 0
keys.each do |key|
    locks.each do |lock|
        if fit?(key, lock)
            part_1 += 1 if fit?(key, lock)
            #puts "#{key} and #{lock} fit"
        else
            #puts "#{key} and #{lock} do NOT fit"
        end
    end
end

puts "Part 1: #{part_1}"
    

