# Alternative solution, using a more Dijkstra-like approach.
# Uses a home-made priority queue, which is probably slow, but anyway results in a much
# faster runtime than my initial solution.

Pos = Struct.new(:x, :y)
State = Struct.new(:direction, :consecutive_steps)

# Very "poor man's priority queue" implementation
class PQueye
  def initialize
    @q = {}
  end

  def push(value, item)
    @q[value] ||= []
    @q[value] << item
  end

  def pop
    lowest_value = @q.keys.min
    result = @q[lowest_value].pop
    @q.delete(lowest_value) if @q[lowest_value].empty?
    [lowest_value, result]
  end

  def empty?
    @q.empty?
  end
end

UP = [0, -1]
DOWN = [0, 1]
LEFT = [-1, 0]
RIGHT = [1, 0]

def opposite?(d1, d2)
  d1.first == -d2.first && d1.last == -d2.last
end

def solve(grid, min_consecutive_steps, max_consecutive_steps)
  visited = {
    Pos.new(0, 0) => Set.new([State.new(RIGHT, 0), State.new(DOWN, 0)])
  }
  height, width = grid.length, grid[0].length
  queue = PQueye.new
  queue.push(0, [Pos.new(0, 0), State.new(RIGHT, 0)])
  queue.push(0, [Pos.new(0, 0), State.new(DOWN, 0)])
  while !queue.empty?
    current_heat_loss, item = queue.pop
    pos, state = item

    return current_heat_loss if pos.x == width - 1 && pos.y == height - 1

    [UP, DOWN, LEFT, RIGHT].each do |direction|
      next if state.direction == direction && state.consecutive_steps == max_consecutive_steps
      next if state.direction != direction && state.consecutive_steps < min_consecutive_steps
      next if opposite?(state.direction, direction) # We can only do 90-degree turns

      new_pos = Pos.new(pos.x + direction.first, pos.y + direction.last)
      next if new_pos.x < 0 || new_pos.y < 0 || new_pos.x >= width || new_pos.y >= height # Out of bounds

      consecutive_steps = state.direction == direction ? state.consecutive_steps + 1 : 1
      new_state = State.new(direction, consecutive_steps)
      new_heat_loss = current_heat_loss + grid[new_pos.y][new_pos.x]

      visited[new_pos] ||= Set.new
      next if visited[new_pos].include?(new_state)

      visited[new_pos] << new_state
      queue.push(new_heat_loss, [new_pos, new_state])
    end
  end

  raise "No solution"
end

grid = File.readlines("17/input").map(&:strip).map(&:chars).map { |row| row.map(&:to_i) }

puts "Part 1: #{solve(grid, 0, 3)}"
puts "Part 2: #{solve(grid, 4, 10)}"
