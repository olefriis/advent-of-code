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
    safe = false
    report.count.times do |i|
        new_report = report[0...i] + (report[i+1...] || [])
        safe ||= within_range(new_report) && (increasing?(new_report) || decreasing?(new_report))
    end
    result += 1 if safe
end

puts result
