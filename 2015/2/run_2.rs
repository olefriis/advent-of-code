use std::fs::File;
use std::io::{self, BufRead};

fn main() -> std::io::Result<()> {
  let file = File::open("2/input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let result: usize = lines.iter()
    .map(|line| {
      let mut edges = line.split('x').map(|edge| edge.parse::<usize>().unwrap()).collect::<Vec<usize>>();
      edges.sort();
      let ribbon = edges[0..2].iter().map(|edge| edge * 2).sum::<usize>();
      let bow = edges.iter().product::<usize>();
      ribbon + bow
    }).sum();

  println!("Result: {}", result);
  Ok(())
}
