# Test input
p1_starting_position = 4
p2_starting_position = 8

# Puzzle input
p1_starting_position = 10
p2_starting_position = 9

turn = 1

die = 1

Configuration = Struct.new(:p1_points, :p2_points, :p1_position, :p2_position)
running_configurations = { Configuration.new(0, 0, p1_starting_position - 1, p2_starting_position - 1) => 1 }

winning_p1 = 0
winning_p2 = 0

turn = 1
i = 1
while running_configurations.length > 0
  puts "iteration #{i}. We have #{running_configurations.length} configurations left."
  i+=1
  new_running_configurations = {}
  running_configurations.each do |configuration, multiplications|
    1.upto(3) do |roll1|
      1.upto(3) do |roll2|
        1.upto(3) do |roll3|
          die = roll1 + roll2 + roll3
          if turn == 1
            p1_position = (configuration.p1_position + die) % 10
            p1_points = configuration.p1_points + p1_position + 1
            if p1_points >= 21
              winning_p1 += multiplications
              new_configuration = nil
            else
              new_configuration = Configuration.new(p1_points, configuration.p2_points, p1_position, configuration.p2_position)
            end
          else
            p2_position = (configuration.p2_position + die) % 10
            p2_points = configuration.p2_points + p2_position + 1
            if p2_points >= 21
              winning_p2 += multiplications
              new_configuration = nil
            else
              new_configuration = Configuration.new(configuration.p1_points, p2_points, configuration.p1_position, p2_position)
            end
          end

          if new_configuration
            new_running_configurations[new_configuration] ||= 0
            new_running_configurations[new_configuration] += multiplications
          end
        end
      end
    end
  end
  running_configurations = new_running_configurations
  if turn == 1
    turn = 2
  else
    turn = 1
  end
end

puts "p1 wins in #{winning_p1} configurations"
puts "p2 wins in #{winning_p2} configurations"
