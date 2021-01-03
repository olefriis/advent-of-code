fn meets_criteria(number: u32) -> bool {
  let digit1 = (number / 100000) % 10;
  let digit2 = (number / 10000) % 10;
  let digit3 = (number / 1000) % 10;
  let digit4 = (number / 100) % 10;
  let digit5 = (number / 10) % 10;
  let digit6 = number % 10;

  let never_decreases = digit1 <= digit2 &&
  digit2 <= digit3 &&
  digit3 <= digit4 &&
  digit4 <= digit5 &&
  digit5 <= digit6;
  let has_double = digit1 == digit2 ||
    digit2 == digit3 ||
    digit3 == digit4 ||
    digit4 == digit5 ||
    digit5 == digit6;

  never_decreases && has_double
}

fn main() {
  let mut matches = 0;
  // Puzzle input: 278384-824795
  for i in 278384..824795 {
    if meets_criteria(i) {
      matches += 1;
    }
  }

  println!("We have {} numbers that match the criteria", matches);
}