require 'set'
require 'pry'
blueprints = {}
File.readlines('19/input', chomp: true).map do |line|
  title, rest = line.split(': ')
  title =~ /Blueprint (\d+)/
  id = $1.to_i

  robot_requirements = {}
  rest.split('.').map do |part|
    robot_part, requirements_part = part.split(' costs ')
    robot_part =~ /Each (.*) robot/
    robot_type = $1

    requirements = {}
    requirements_part.split(' and ').map do |requirement|
      requirement =~ /(\d+) (.*)/
      amount, type = $1.to_i, $2
      requirements[type] = amount
    end
    robot_requirements[robot_type] = requirements
  end
  blueprints[id] = robot_requirements
end

Configuration = Struct.new(:resources, :robots, :upcoming_robot) do
  def can_build?(requirements)
    requirements.all? { |resource, amount| resources[resource] >= amount }
  end

  def build(robot_type, requirements)
    new_resources = self.resources.dup
    requirements.each do |resource, amount|
      new_resources[resource] -= amount
    end

    Configuration.new(new_resources, robots, robot_type)
  end

  def pass_time
    new_resources = self.resources.dup
    robots.each {|robot_type, number| new_resources[robot_type] += number}

    new_robots = if upcoming_robot
      new_robots = self.robots.dup
      new_robots[upcoming_robot] += 1
      new_robots
    else
      robots
    end

    Configuration.new(new_resources, new_robots, nil)
  end
end

def solve(blueprint, iterations)
  puts "Solving for blueprint #{blueprint}"
  initial_resources = {'ore' => 0, 'clay' => 0, 'obsidian' => 0, 'geode' => 0}
  initial_robots = {'ore' => 1, 'clay' => 0, 'obsidian' => 0, 'geode' => 0}

  max_resources_required = {'ore' => 0, 'clay' => 0, 'obsidian' => 0, 'geode' => 1000}
  blueprint.each do |robot_type, requirements|
    requirements.each do |resource, amount|
      max_resources_required[resource] = [max_resources_required[resource], amount].max
    end
  end

  configurations = [Configuration.new(initial_resources, initial_robots, nil)]
  iterations.times do |i|
    puts "Iteration #{i}. Configurations: #{configurations.length}"
    new_configurations = []

    configurations.each do |configuration|
      new_configurations << configuration # Consider _not_ doing anything this round

      # Attempt to build any robot we have resources for, as long as we're not already at
      # "max required capacity" for it (we can only build one new robot per minute anyway)
      blueprint.each do |robot_type, requirements|
        if configuration.can_build?(requirements) && max_resources_required[robot_type] > configuration.robots[robot_type]
          new_configurations << configuration.build(robot_type, requirements)
        end
      end
    end

    configurations = new_configurations
      # "Shrink" configurations where resources are above the "max required capacity"
      .each do |configuration|
        configuration.resources.keys.each do |resource|
          configuration.resources[resource] = [configuration.resources[resource], max_resources_required[resource]].min
        end
      end
      .uniq
      # Then let time pass for each of them
      .map {|configuration| configuration.pass_time}
  end

  configurations.map {|c| c.resources['geode']}.max
end

part1 = blueprints.map {|id, blueprint| id * solve(blueprint, 24) }.inject(&:+)
puts "Part 1: #{part1}"

part2 = blueprints.keys.sort[0...3].map {|id| solve(blueprints[id], 32) }.inject(&:*)
puts "Part 2: #{part2}"
