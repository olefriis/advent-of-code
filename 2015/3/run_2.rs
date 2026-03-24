use std::collections::HashSet;
use std::fs::File;
use std::io::{self, Read};

fn main() -> std::io::Result<()> {
  let file = File::open("3/input")?;
  let mut visited = HashSet::new();
  visited.insert((0, 0));
  let mut santas: Vec<(i32, i32)> = vec![(0, 0), (0, 0)];
  io::BufReader::new(file).bytes()
    .for_each(|byte| {
      let b = byte.unwrap();
      match b {
        b'>' => santas[0].0 += 1,
        b'<' => santas[0].0 -= 1,
        b'^' => santas[0].1 += 1,
        b'v' => santas[0].1 -= 1,
        _ => panic!("Unexpected byte: {}", b)
      }
      visited.insert((santas[0].0, santas[0].1));
      santas = vec![santas[1], santas[0]];
    });
  println!("Visited: {}", visited.len());
  Ok(())
}
