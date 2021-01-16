fn main() -> std::io::Result<()> {
  let mut digits: Vec<i32> = std::fs::read_to_string("16/input").unwrap()
    .chars()
    .map(|char| char.to_digit(10).unwrap() as i32)
    .collect();

  for _ in 0..100 {
    digits = (0..digits.len()).map(|i| {
      let pattern = FftIter::new(i);
      digits.iter().zip(pattern).map(|(digit, pattern_value)| *digit as i32 * pattern_value).sum::<i32>().abs() % 10
    }).collect();
  }

  let first_8_digits = digits.iter().take(8).map(|n| n.to_string()).collect::<Vec<String>>().join("");
  println!("First 8 digits: {}", first_8_digits);

  Ok(())
}

struct FftIter {
  iteration: usize,
  i: usize,
}

impl FftIter  {
  fn new(iteration: usize) -> FftIter {
    FftIter { iteration, i: 0 }
  }
}

impl Iterator for FftIter {
  type Item = i32;

  fn next(&mut self) -> Option<i32> {
    self.i += 1;

    let base_pattern = vec![0, 1, 0, -1];
    let index = (((self.i) / (self.iteration + 1)) % 4) as usize;
    return Some(base_pattern[index])
  }
}
