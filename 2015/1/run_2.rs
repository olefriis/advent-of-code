use std::fs::File;
use std::io::{self, Read};

fn main() -> std::io::Result<()> {
  let file = File::open("1/input")?;
  let mut floor = 0;
  let result = io::BufReader::new(file).bytes()
    .map(|byte| {
      floor += if byte.unwrap() == b'(' { 1 } else { -1 };
      floor
    })
    .position(|floor| floor == -1).unwrap() + 1;
  println!("Result: {}", result);
  Ok(())
}
