mod intcode;
use intcode::{Intcode, read_program};

struct Coverage {
  first: usize,
  last: usize,
}

fn main() -> std::io::Result<()> {
  let program: Vec<i64> = read_program("19/input");

  let mut coverages: Vec<Coverage> = vec![];
  // Let's skip the first 10 lines, as they are a little fuzzy
  for y in 10.. {
    let mut start_x = if coverages.len() == 0 { 0 } else { coverages[coverages.len()-1].first-1 };
    // Find the start of the beam, which is the first x with a result of 1
    while !affected(&program, start_x, y) {
      start_x += 1;
    }

    let mut end_x = if coverages.len() == 0 { 10 } else { coverages[coverages.len()-1].last+2 };
    while !affected(&program, end_x, y) {
      end_x -= 1;
    }
    coverages.push(Coverage { first: start_x, last: end_x });

    if coverages.len() >= 100 {
      let start_x = coverages[coverages.len()-100..coverages.len()].iter().map(|c| c.first).max().unwrap();
      let end_x = coverages[coverages.len()-100..coverages.len()].iter().map(|c| c.last).min().unwrap();
      if end_x >= start_x + 99 {
        println!("Got it at {}", y);
        let rectangle_start_x = start_x;
        let rectangle_start_y = y - 99;
        println!("Rectangle starts at {},{}, so result is {}", rectangle_start_x, rectangle_start_y, rectangle_start_x * 10000 + rectangle_start_y);
        return Ok(())
      }
    }
  }

  Ok(())
}

fn affected(program: &Vec<i64>, x: usize, y: usize) -> bool {
  let mut intcode = Intcode::new(program);
  let input = vec![x as i64, y as i64];
  match intcode.run(&input) {
    Some(0) => false,
    Some(1) => true,
    any => panic!("Unexpected output: {:?}", any),
  }
}