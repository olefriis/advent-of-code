require 'set'
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
  initial_resources = {'ore' => 0, 'clay' => 0, 'obsidian' => 0, 'geode' => 0}
  initial_robots = {'ore' => 1, 'clay' => 0, 'obsidian' => 0, 'geode' => 0}

  configurations = [Configuration.new(initial_resources, initial_robots, nil)]
  iterations.times do |i|
    new_configurations = []
    configurations.each do |configuration|
      number_of_robots_we_can_build = 0
      # Attempt to build any robot we have resources for
      blueprint.each do |robot_type, requirements|
        if configuration.can_build?(requirements)
          new_configurations << configuration.build(robot_type, requirements)
          number_of_robots_we_can_build += 1
        end
      end

      # Only consider _not_ doing anything if we're unable to make every single robot type that we dig resources for
      robots_we_dig_resources_for = blueprint.keys.select {|robot_type| blueprint[robot_type].all? {|resource, amount| amount == 0 || configuration.robots[resource] > 0}}
      new_configurations << configuration if number_of_robots_we_can_build < robots_we_dig_resources_for.length
    end

    # Then let time pass for each of them
    configurations = new_configurations.uniq.map {|configuration| configuration.pass_time}

    # Heuristic found somewhere random on the internet: Prune so we only carry on "the 5000 best" configurations,
    # where geode resources are the most important, then geode robots, then obisian resources, then obsidian robots, etc.
    #
    # However, if we instead go for "the 1000 best", it gives the wrong answer. So this seems like a completely
    # arbitrary heuristic.
    configurations = configurations.uniq.max_by(5000) do |configuration|
      [
        configuration.resources['geode'], configuration.robots['geode'],
        configuration.resources['obsidian'], configuration.robots['obsidian'],
        configuration.resources['clay'], configuration.robots['clay'],
        configuration.resources['ore'], configuration.robots['ore'],
      ]
    end
  end

  configurations.map {|c| c.resources['geode']}.max
end

part1 = blueprints.map {|id, blueprint| id * solve(blueprint, 24) }.inject(&:+)
puts "Part 1: #{part1}"

part2 = blueprints.keys.sort[0...3].map {|id| solve(blueprints[id], 32) }.inject(&:*)
puts "Part 2: #{part2}"
