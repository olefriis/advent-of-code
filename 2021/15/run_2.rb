original_grid = File.readlines('input').map { |line| line.strip.split('').map(&:to_i) }


# Weird kind of priority queue.
# It only makes sense when the priority grows all the time (which it does with Dijkstra's algorithm), and it is only
# performant when the difference between the max and min priority is limited (is is at most 9 in this exercise). This
# cuts the runtime of this solution from 80s to 2.5s.
class HalfArsedPriorityQueue
  def initialize
    @base_value = 0
    @keys_to_values = {}
    @values_to_keys = []
  end

  def put(key, value)
    raise "Hey, you're holding it wrong! Minimum value from now on is #{@base_value}, you tried with #{value}" if value < @base_value

    existing_value = @keys_to_values[key]
    if existing_value
      return if existing_value < value
      @values_to_keys[existing_value - @base_value].delete(key)
    end

    @keys_to_values[key] = value
    @values_to_keys[value - @base_value] ||= []
    @values_to_keys[value - @base_value].push(key)
  end

  def pull
    return [nil, nil] if @keys_to_values.empty?

    while !@values_to_keys.empty? && (@values_to_keys[0].nil? || @values_to_keys[0].empty?)
      @values_to_keys.shift
      @base_value += 1
    end

    return_key = @values_to_keys[0].pop
    @keys_to_values.delete(return_key)
    [return_key, @base_value]
  end

  def empty?
    @keys_to_values.empty?
  end
end

grid = []
5.times do |repeat_y|
  original_grid.length.times do |y|
    line = []
    5.times do |repeat_x|
      original_grid[y].length.times do |x|
        original_entry = original_grid[y][x]
        new_entry = original_entry + repeat_x + repeat_y
        while new_entry > 9
          new_entry -= 9
        end
        line << new_entry
      end
    end
    grid << line
  end
end

Pos = Struct.new(:x, :y)
visited = {}

def visit(pos, risk, grid, visited, edge)
  return if visited[pos]
  visited[pos] = risk
  neighbours = [[0, -1], [-1, 0], [0, 1], [1, 0]].map do |dx, dy|
    Pos.new(pos.x + dx, pos.y + dy)
  end.filter do |neighbour|
    neighbour.y >= 0 && neighbour.y < grid.size && neighbour.x >= 0 && neighbour.x < grid[0].size
  end.filter do |neighbour|
    !visited.has_key?(neighbour)
  end

  neighbours.each do |neighbour|
    edge.put(neighbour, risk + grid[neighbour.y][neighbour.x])
  end
end

edge = HalfArsedPriorityQueue.new
edge.put(Pos.new(0, 0), 0)

while !edge.empty?
  pos, risk = edge.pull
  visit(pos, risk, grid, visited, edge)
end

puts visited[Pos.new(grid[0].length - 1, grid.length - 1)]
