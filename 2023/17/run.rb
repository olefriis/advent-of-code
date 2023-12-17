Pos = Struct.new(:x, :y)
State = Struct.new(:direction, :consecutive_steps)

UP = [0, -1]
DOWN = [0, 1]
LEFT = [-1, 0]
RIGHT = [1, 0]

def opposite?(d1, d2)
  d1.first == -d2.first && d1.last == -d2.last
end

def solve(grid, min_consecutive_steps, max_consecutive_steps)
  # For each index: List all possible states, along with their heat loss.
  # Each index can have any combination of the (direction, consecutive_steps) for States, and keeps track of the minimum heat loss for each state.
  lowest_heat_state_map = {
    Pos.new(0, 0) => {
      State.new(RIGHT, 0) => 0,
      State.new(DOWN, 0) => 0,
    }
  }
  edge = [
    [Pos.new(0, 0), State.new(RIGHT, 0)],
    [Pos.new(0, 0), State.new(DOWN, 0)],
  ]
  while !edge.empty?
    new_edge = Set.new
    edge.each do |pos, state|
      current_heat_loss = lowest_heat_state_map[pos][state]

      [UP, DOWN, LEFT, RIGHT].each do |direction|
        next if state.direction == direction && state.consecutive_steps == max_consecutive_steps
        next if state.direction != direction && state.consecutive_steps < min_consecutive_steps
        next if opposite?(state.direction, direction) # We can only do 90-degree turns

        new_pos = Pos.new(pos.x + direction.first, pos.y + direction.last)
        next if new_pos.x < 0 || new_pos.y < 0 || new_pos.x >= grid[0].length || new_pos.y >= grid.length # Out of bounds

        consecutive_steps = state.direction == direction ? state.consecutive_steps + 1 : 1
        new_state = State.new(direction, consecutive_steps)
        new_heat_loss = current_heat_loss + grid[new_pos.y][new_pos.x]

        lowest_heat_state_map[new_pos] ||= {}
        existing_heat_state = lowest_heat_state_map[new_pos][new_state]
        if !existing_heat_state || existing_heat_state > new_heat_loss
          lowest_heat_state_map[new_pos][new_state] = new_heat_loss
          new_edge << [new_pos, new_state]
        end
      end
    end

    edge = new_edge
  end

  lowest_heat_state_map[Pos.new(grid[0].length - 1, grid.length - 1)].values.min
end

grid = File.readlines("17/input").map(&:strip).map(&:chars).map { |row| row.map(&:to_i) }

puts "Part 1: #{solve(grid, 0, 3)}"
puts "Part 2: #{solve(grid, 4, 10)}"
