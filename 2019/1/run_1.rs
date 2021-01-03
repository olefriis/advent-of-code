use std::fs::File;
use std::io::{self, BufRead};

fn main() -> std::io::Result<()> {
  let file = File::open("1/input")?;
  let sum: i32 = io::BufReader::new(file).lines()
    .map(|line| line.unwrap().parse::<i32>().unwrap())
    .map(|mass| (mass / 3) - 2)
    .fold(0, |a, b| a+b);
  println!("Sum: {}", sum);
  Ok(())
}
