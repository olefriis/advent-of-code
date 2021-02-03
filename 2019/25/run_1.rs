mod intcode;
use intcode::{Intcode, read_program};

fn main() -> std::io::Result<()> {
  let program: Vec<i64> = read_program("25/input");
  let input_string = "south
take food ration
west
take sand
north
north
east
take astrolabe
west
south
south
east
north
north
west
east
east
take coin
west
south
east
take cake
south
take weather machine
west
take ornament
west
take jam
east
east
north
east
east
east
inv
drop coin
drop cake
drop sand
drop jam
south
inv
";

  let input: Vec<i64> = input_string.chars().map(|c| c as i64).collect();
  let input_iter = input.into_iter();
  let mut intcode = Intcode::new(&program, Box::new(input_iter));

  loop {
    match intcode.run() {
      None => break,
      Some(value) => {
        if value > 200 {
          println!("Big result: {}", value);
        } else {
          print!("{}", (value as u8) as char);
        }
      },
    };
  }

  Ok(())
}
