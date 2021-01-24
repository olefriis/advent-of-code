mod intcode;
use intcode::{Intcode, read_program};

fn main() -> std::io::Result<()> {
  let program: Vec<i64> = read_program("21/input");
  run_with(&program, "OR H J
OR E T
AND I T
OR T J
OR E T
AND F T
OR T J
OR A T
AND A T
AND B T
AND C T
NOT T T
AND T J
AND D J
RUN
");

  Ok(())
}

fn run_with(program: &Vec<i64>, input_string: &str) {
  println!("Trying input\n{}", input_string);

  let mut intcode = Intcode::new(&program);
  let input = input_string.chars().map(|c| c as i64).collect();

  loop {
    match intcode.run(&input) {
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
}
