use std::fs::File;
use std::io::{self, BufRead};

fn main() -> std::io::Result<()> {
  let file = File::open("8/input")?;

  let lines: Vec<Vec<u32>> = io::BufReader::new(file).lines().map(|line| {
    line.unwrap().chars().map(|char| char.to_digit(10).unwrap()).collect()
  }).collect();

  let first_line = lines.iter().next().unwrap();
  let layers: Vec<&[u32]> = first_line[0..].chunks(25*6).collect();

  for y in 0..6 {
    for x in 0..25 {
      let mut pixel = 2;
      for i in 0..layers.len() {
        if pixel == 2 {
          pixel = layers[i][y*25+x];
        }
      }
      print!("{}", match pixel {
        0 => "*",
        1 => " ",
        _ => "?",
      })
    }
    println!("");
  }

  Ok(())
}