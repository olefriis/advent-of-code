use std::cmp::min;

fn main() -> std::io::Result<()> {
  let original_digits: Vec<i32> = std::fs::read_to_string("16/input").unwrap()
    .chars()
    .map(|char| char.to_digit(10).unwrap() as i32)
    .collect();

  let offset = original_digits.iter().take(7).fold(0, |acc, x| acc*10 + x) as usize;
  println!("Offset: {}", offset);

  let mut digits: Vec<i32> = original_digits.iter().cycle().cloned().take(10000 * original_digits.len()).skip(offset).collect();
  println!("We have {} digits", digits.len());

  for _ in 0..100 {
    let accumulated_sums = AccumulatedSums::new(&digits);
    let mut next_digits = Vec::with_capacity(digits.len());

    for row in 0..digits.len() {
      let base_phase = vec![1, 0, -1, 0];
      let mut base_phase_iter = base_phase.iter().cycle(); // Shifted to accommodate skipping the first  `iteration` numbers
      let chunk_size = offset + row + 1;
      let mut start_of_chunk = row;
      let mut next_digit = 0;
      while start_of_chunk < digits.len() {
        let chunk = accumulated_sums.sum_of_continuous_block(start_of_chunk, start_of_chunk + chunk_size);
        let multiplication = base_phase_iter.next().unwrap();
        next_digit += multiplication * chunk;
        start_of_chunk += chunk_size;
      }
      next_digits.push(next_digit % 10);
    }

    digits = next_digits;
  }

  let first_8_digits = digits.iter().take(8).map(|n| n.to_string()).collect::<Vec<String>>().join("");
  println!("First 8 digits: {}", first_8_digits);

  Ok(())
}

struct AccumulatedSums {
  sums: Vec<i32>,
}

impl AccumulatedSums {
  fn new(digits: &Vec<i32>) -> AccumulatedSums {
    let mut sums = Vec::with_capacity(digits.len() + 1);
    let mut current_sum = 0;
    sums.push(current_sum);
    for digit in digits {
      current_sum += digit;
      sums.push(current_sum);
    }

    AccumulatedSums { sums }
  }

  // Gives the sum of all elements from (and including) `from` and to (excluding) `to`
  fn sum_of_continuous_block(&self, from: usize, to: usize) -> i32 {
    self.sums[min(to, self.sums.len()-1)] - self.sums[from]
  }
}
