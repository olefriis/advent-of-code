require 'set'

numbers = File.readlines('input').map(&:to_i).sort
p numbers
goal = numbers.last

unused = Set.new(numbers)
used = Set.new

def attempt(current, used, unused, goal)
  if current == goal
    return 1
  end

  result = 0

  [current+1, current+2, current+3].each do |c|
    if unused.include?(c)
      used.add c
      unused.delete c

      result += attempt(c, used, unused, goal)

      unused.add c
      used.delete c
    end
  end

  result
end

possibilities = attempt(0, used, unused, goal)

puts "#{possibilities} possibilities"
