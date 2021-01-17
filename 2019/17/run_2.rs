mod intcode;
use intcode::{Intcode, read_program};
use std::io;

fn main() -> std::io::Result<()> {
  let mut program: Vec<i64> = read_program("17/input");
  // Wake up
  program[0] = 2;

  let mut intcode = Intcode::new(&program);
  let mut input = vec![];
  let mut current_line_length = 0;
  loop {
    match intcode.run(&input) {
      None => { return Ok(()) },
      Some(10) => {
        println!("");
        if current_line_length > 2 && current_line_length < 30 {
          // We are probably being queried
          input = read_line().unwrap().chars().map(|c| c as i64).collect();
          println!("New input: {:?}", input);
        }

        current_line_length = 0;
      },
      Some(value) => {
        if value > 1000 {
          println!("Got high value, probably the dust collected: {}", value);
        } else {
          current_line_length += 1;
          print!("{}", (value as u8) as char);
        }
      }
    }
  }
}

fn read_line() -> io::Result<String> {
  let mut buffer = String::new();
  io::stdin().read_line(&mut buffer)?;
  Ok(buffer)
}