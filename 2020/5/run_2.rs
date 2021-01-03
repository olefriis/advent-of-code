use std::fs::File;
use std::io::{self, BufRead};
use std::collections::BTreeSet;

fn main() -> std::io::Result<()> {
  let file = File::open("input")?;
  let lines = io::BufReader::new(file).lines();

  //println!("Got {} lines", lines.count()); // Ownership transfer!

  let mut seat_ids = Vec::new();
  for line in lines {
    let l = line?;
    seat_ids.push(seat_id(&l));
  }
  println!("Got {} seat IDs", seat_ids.len());

  let mut all_seats = BTreeSet::new();
  for seat_id in 32..849 {
    all_seats.insert(seat_id);
  }

  for seat_id in seat_ids {
    all_seats.remove(&seat_id);
  }

  println!("Remaining seats: {}", all_seats.len());
  println!("First remaining seats {}", all_seats.iter().next().unwrap());

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