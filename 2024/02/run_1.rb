require 'pry'
lines = File.readlines('02/input').map(&:strip)

def within_range(report)
    report.each_cons(2) do |a, b|
        diff = (a - b).abs
        return false if diff > 3 || diff < 1
    end
    true
end

def increasing?(report)
    report.each_cons(2) do |a, b|
        return false if a <= b
    end
    true
end

def decreasing?(report)
    report.each_cons(2) do |a, b|
        return false if a >= b
    end
    true
end

result = 0
lines.each do |line|
    report = line.split.map(&:to_i)
    result += 1 if within_range(report) && (increasing?(report) || decreasing?(report))
end

puts result
