use std::fs::File;
use std::io::{self, Read};

fn main() -> std::io::Result<()> {
  let file = File::open("1/input")?;
  let sum: i32 = io::BufReader::new(file).bytes()
    .map(|byte| if byte.unwrap() == b'(' { 1 } else { -1 })
    .sum();
  println!("Sum: {}", sum);
  Ok(())
}
