use std::fs::File;
use std::io::{self, BufRead};

fn main() -> std::io::Result<()> {
  let file = File::open("2/input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let result: usize = lines.iter()
    .map(|line| {
      let edges = line.split('x').map(|edge| edge.parse::<usize>().unwrap()).collect::<Vec<usize>>();
      let side_areas = vec![edges[0] * edges[1], edges[1] * edges[2], edges[0] * edges[2]];
      let smallest_side_area = *side_areas.iter().min().unwrap();
      let surface = side_areas.iter().sum::<usize>() * 2;
      surface + smallest_side_area
    }).sum();

  println!("Result: {}", result);
  Ok(())
}
