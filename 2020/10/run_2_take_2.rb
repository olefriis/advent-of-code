# Uses memoization.
# My preferred approach.

def remaining_combinations(current, unused_adapters, memory=[])
  return 1 if unused_adapters.count < 2

  memory[unused_adapters.count] ||= [current+1, current+2, current+3]
    .select {|c| unused_adapters.include?(c)}
    .map {|c| remaining_combinations(c, unused_adapters[unused_adapters.index(c)..-1], memory)}
    .sum
end

adapters = File.readlines('input').map(&:to_i).sort
puts remaining_combinations(0, adapters)
