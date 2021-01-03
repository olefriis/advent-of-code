use std::fs::File;
use std::io::{self, BufRead};

fn main() -> std::io::Result<()> {
  let file = File::open("1/input")?;
  let sum: i32 = io::BufReader::new(file).lines()
    .map(|line| line.unwrap().parse::<i32>().unwrap())
    .map(|mass| {
      let mut remaining_fuel = (mass / 3) - 2;
      let mut used_fuel = 0;
      while remaining_fuel >= 0 {
        used_fuel += remaining_fuel;
        remaining_fuel = (remaining_fuel / 3) - 2;
      }
      used_fuel
    })
    .fold(0, |a, b| a+b);
  println!("Sum: {}", sum);
  Ok(())
}
