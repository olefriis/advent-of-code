lines = File.readlines('02/input').map(&:strip)

def within_range?(report) = report.each_cons(2).all? { |a, b| diff = (a - b).abs; diff < 4 && diff > 0 }
def increasing?(report) = report.each_cons(2).all? { |a, b| a > b }
def decreasing?(report) = report.each_cons(2).all? { |a, b| a < b }
def valid?(report) = within_range?(report) && (increasing?(report) || decreasing?(report))

reports = lines.map { |line| line.split.map(&:to_i) }

result_1 = reports.count { |report| valid?(report) }
puts "1: #{result_1}"

result_2 = reports.count do |report|
    report.count.times.any? do |i|
        new_report = report[0...i] + report[i+1...]
        valid?(new_report)
    end
end
puts "2: #{result_2}"
