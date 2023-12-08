lines = File.readlines('08/input').map(&:strip)

DIRECTIONS = lines[0].chars

PATHS = {}
lines[2..-1].each do |line|
  line =~ /(.*) = \((.*), (.*)\)/ or raise "Invalid line: #{line}"
  origin, left, right = $1, $2, $3
  PATHS[origin] = [left, right]
end

def solve(position, &block)
  steps = 0
  while !block.call(position)
    direction = DIRECTIONS[steps % DIRECTIONS.length]
    left, right = PATHS[position]
    if direction == 'L'
      position = left
    elsif direction == 'R'
      position = right
    else
      raise "Invalid direction: #{direction}"
    end
    steps += 1
  end
  steps
end

puts "Part 1: #{solve('AAA') {|p| p == 'ZZZ'}}"

def primes_in(n)
  attempt = 2
  result = []
  while n > 2
    if n % attempt == 0
      n /= attempt
      result << attempt
    else
      attempt += 1
    end
  end
  result.tally
end

def merge_primes(primes1, primes2)
  result = primes1.clone
  primes2.keys.each do |prime|
    if result[prime]
      result[prime] = [result[prime], primes2[prime]].max
    else
      result[prime] = primes2[prime]
    end
  end
  result
end

positions = PATHS.keys.select {|p| p.end_with?('A')}
steps = positions.map {|p| solve(p) {|p| p.end_with?('Z')}}
primes = steps.map {|s| primes_in(s)}
merged_primes = primes.reduce {|a, b| merge_primes(a, b)}
part2 = merged_primes.map {|prime, count| prime ** count}.reduce(:*)
puts "Part 2: #{part2}"
