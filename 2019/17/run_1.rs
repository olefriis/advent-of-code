mod intcode;
use intcode::{Intcode, read_program};

fn main() -> std::io::Result<()> {
  let program: Vec<i64> = read_program("17/input");
  let mut intcode = Intcode::new(&program);
  let input = vec![];

  let mut lines = vec![];
  let mut next_line = vec![];
  loop {
    match intcode.run(&input) {
      None => break,
      Some(value) => {
        print!("{}", (value as u8) as char);
        if value == 10 {
          lines.push(next_line);
          next_line = vec![];
        } else {
          next_line.push(value);
        }
      },
    };
  }

  let mut sum_of_alignment_parameters = 0;
  // Top and bottom rows cannot contain intersections. Besides, last line is blank.
  for y in 1..lines.len()-2 {
    // Leftmost and rightmost columns cannot contain intersections
    for x in 1..lines[y].len()-1 {
      if lines[y][x] == 35 &&
        lines[y-1][x] == 35 &&
        lines[y+1][x] == 35 &&
        lines[y][x-1] == 35 &&
        lines[y][x+1] == 35 {
          sum_of_alignment_parameters += x*y;
      }
    }
  }

  println!("Sum of alignment parameters: {}", sum_of_alignment_parameters);

  Ok(())
}
