use std::collections::HashSet;
use std::fs::File;
use std::io::{self, Read};

fn main() -> std::io::Result<()> {
  let file = File::open("3/input")?;
  let mut visited = HashSet::new();
  visited.insert((0, 0));
  let mut santa = (0, 0);
  io::BufReader::new(file).bytes()
    .for_each(|byte| {
      let b = byte.unwrap();
      match b {
        b'>' => santa.0 += 1,
        b'<' => santa.0 -= 1,
        b'^' => santa.1 += 1,
        b'v' => santa.1 -= 1,
        _ => panic!("Unexpected byte: {}", b)
      }
      visited.insert(santa);
    });
  println!("Visited: {}", visited.len());
  Ok(())
}
