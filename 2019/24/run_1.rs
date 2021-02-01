use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashSet;

fn main() -> std::io::Result<()> {
  let file = File::open("24/input")?;
  let mut lines: Vec<Vec<char>> = io::BufReader::new(file).lines().map(|line| line.unwrap().chars().collect()).collect();

  let mut seen_biodiversity_ratings = HashSet::new();
  seen_biodiversity_ratings.insert(biodiversity_rating(&lines));

  loop {
    let mut new_lines = vec![];

    for y in 0..lines.len() {
      let mut new_line = vec![];

      for x in 0..lines[y].len() {
        let mut neighbours = 0;
        for n in vec![(-1,0), (1,0), (0,-1), (0,1)].iter() {
          let nx = x as i32 + n.0;
          let ny = y as i32 + n.1;
          if ny >= 0 && ny < lines.len() as i32 && nx >= 0 && nx < lines[ny as usize].len() as i32 {
            if lines[ny as usize][nx as usize] == '#' {
              neighbours += 1;
            }
          }
        }

        if lines[y][x] == '#' {
          new_line.push(if neighbours == 1 { '#' } else { '.' });
        } else {
          new_line.push(if neighbours == 1 || neighbours == 2 { '#' } else { '.' });
        }
      }

      new_lines.push(new_line);
    }
    lines = new_lines;

    let new_biodiversity_rating = biodiversity_rating(&lines);
    if seen_biodiversity_ratings.contains(&new_biodiversity_rating) {
      println!("Got {} twice", new_biodiversity_rating);
      return Ok(());
    }
    seen_biodiversity_ratings.insert(new_biodiversity_rating);
  }
}

fn biodiversity_rating(lines: &Vec<Vec<char>>) -> u32 {
  let mut factor = 1;
  let mut result = 0;

  for y in 0..lines.len() {
    for x in 0..lines[y].len() {
      if lines[y][x] == '#' {
        result += factor;
      }
      factor *= 2;
    }
  }

  result
}