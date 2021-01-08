use std::fs::File;
use std::io::{self, BufRead};

fn main() -> std::io::Result<()> {
  let file = File::open("8/input")?;

  let lines: Vec<Vec<u32>> = io::BufReader::new(file).lines().map(|line| {
    line.unwrap().chars().map(|char| char.to_digit(10).unwrap()).collect()
  }).collect();

  let first_line = lines.iter().next().unwrap();
  let layer_with_fewest_zeroes = first_line.chunks(25*6).min_by_key(|chunk| chunk.iter().filter(|e| **e == 0).count());
  match layer_with_fewest_zeroes {
    None => panic!("Uh, no layers...?"),
    Some(layer) => {
      let one_digits = layer.iter().filter(|e| **e == 1).count();
      let two_digits = layer.iter().filter(|e| **e == 2).count();
      println!("Result: {}", one_digits * two_digits);
    }
  }

  Ok(())
}