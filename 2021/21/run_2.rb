lines = File.readlines('input').map(&:strip)
p1_starting_position = lines[0].split(': ').last.to_i
p2_starting_position = lines[1].split(': ').last.to_i

Configuration = Struct.new(:p1_points, :p2_points, :p1_position, :p2_position)

# Subtract 1 from starting positions to make it easier to use % below
configurations = { Configuration.new(0, 0, p1_starting_position - 1, p2_starting_position - 1) => 1 }
winning_p1, winning_p2 = 0, 0
p1_turn = true

iteration = 1
while configurations.length > 0
  puts "iteration #{iteration}. We have #{configurations.length} configurations left."
  iteration += 1

  new_configurations = Hash.new { |h, k| h[k] = 0 }
  configurations.each do |configuration, multiplications|
    [1, 2, 3].each do |roll1|
      [1, 2, 3].each do |roll2|
        [1, 2, 3].each do |roll3|
          die = roll1 + roll2 + roll3

          p1_points, p2_points = configuration.p1_points, configuration.p2_points
          p1_position, p2_position = configuration.p1_position, configuration.p2_position
          if p1_turn
            p1_position = (p1_position + die) % 10
            p1_points += p1_position + 1
          else
            p2_position = (p2_position + die) % 10
            p2_points += p2_position + 1
          end

          if p1_points >= 21
            winning_p1 += multiplications
          elsif p2_points >= 21
            winning_p2 += multiplications
          else
            new_configuration = Configuration.new(p1_points, p2_points, p1_position, p2_position)
            new_configurations[new_configuration] += multiplications
          end
        end
      end
    end
  end
  configurations = new_configurations
  p1_turn = !p1_turn
end

puts "p1 wins in #{winning_p1} configurations"
puts "p2 wins in #{winning_p2} configurations"
