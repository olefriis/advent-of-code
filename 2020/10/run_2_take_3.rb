# Makes use of the fact that we do not have "skips" in the list of 2, only 1 and 3.
# Elegant solution, but I still think it's cheating a bit...

tribonaccis = [1,1,2,4,7]
puts [0, *File.readlines('input')]
  .map(&:to_i)
  .sort
  .each_cons(2)
  .map {|a1, a2| (a2-a1).to_s}
  .join
  .split(/3+/)
  .map {|s| tribonaccis[s.length]}
  .reduce(&:*)
