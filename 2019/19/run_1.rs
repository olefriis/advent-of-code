mod intcode;
use intcode::{Intcode, read_program};

fn main() -> std::io::Result<()> {
  let program: Vec<i64> = read_program("19/input");

  let mut affected_positions = 0;
  for y in 0..50 {
    for x in 0..50 {
      let input = vec![x, y];
      let mut intcode = Intcode::new(&program);
      let result = intcode.run(&input).unwrap();
      if result == 0 {
        print!(".");
      } else if result == 1 {
        print!("#");
        affected_positions += 1;
      } else {
        panic!("Unexpected result: {}", result);
      }
    }
    println!("");
  }

  println!("{} affected positions", affected_positions);

  Ok(())
}
