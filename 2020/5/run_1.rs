use std::fs::File;
use std::io::{self, BufRead};

fn main() -> std::io::Result<()> {
  let file = File::open("input")?;
  let lines = io::BufReader::new(file).lines();

  //println!("Got {} lines", lines.count()); // Ownership transfer!

  let mut seat_ids = Vec::new();
  for line in lines {
    let l = line?;
    seat_ids.push(seat_id(&l));
  }

  let max = seat_ids.iter().max().unwrap();
  println!("Biggest seat ID: {}", max);

  Ok(())
}

fn seat_id(seat: &String) -> u32 {
  let mut result = 0;

  for c in seat.chars() {
    result *= 2;
    if c == 'B' || c == 'R' {
      result += 1;
    }
  }

  result
}