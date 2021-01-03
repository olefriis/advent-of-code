use std::fs::File;
use std::io::{self, BufRead};

struct Bus {
  id: i64,
  offset: i64,
}

fn main() -> std::io::Result<()> {
  let file = File::open("input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines()
    .map(|line| line.unwrap())
    .collect();

  let buses: Vec<Bus> = lines[1].split(',').enumerate()
    .filter(|(_offset, bus_id)| *bus_id != "x")
    .map(|(offset, bus_id)| Bus { id: bus_id.parse::<i64>().unwrap(), offset: offset as i64 })
    .collect();

  let mut start_time: i64 = 0;
  loop {
    let matches: Vec<&Bus> = buses.iter()
      .filter(|bus| (start_time + bus.offset) % bus.id == 0)
      .collect();
    if matches.len() == buses.len() {
      break;
    }
    start_time += matches.iter().fold(1, |acc, bus| acc * bus.id);
  }

  println!("{}", start_time);
  Ok(())
}
