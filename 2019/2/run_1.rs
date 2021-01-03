use std::fs::File;
use std::io::{self, BufRead};

fn run(program: &mut Vec<usize>) {
  let mut instruction_pointer = 0;
  loop {
    let opcode = program[instruction_pointer];
    match opcode {
      99 => return,
      1 => {
        let parameter1 = program[program[instruction_pointer+1]];
        let parameter2 = program[program[instruction_pointer+2]];
        let destination = program[instruction_pointer+3];
        program[destination] = parameter1 + parameter2;
        instruction_pointer += 4;
      },
      2 => {
        let parameter1 = program[program[instruction_pointer+1]];
        let parameter2 = program[program[instruction_pointer+2]];
        let destination = program[instruction_pointer+3];
        program[destination] = parameter1 * parameter2;
        instruction_pointer += 4;
      },
      _ => {
        panic!("Unknown instruction at position {}: {}", instruction_pointer, opcode);
      }
    }
  }
}

fn main() -> std::io::Result<()> {
  let file = File::open("input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let mut program: Vec<usize> = lines.iter()
    .flat_map(|line| line.split(',').map(|intcode_as_string| intcode_as_string.parse::<usize>().unwrap()))
    .collect();
  //println!("Program: {:?}", program);

  // "before running the program, replace position 1 with the value 12 and replace position 2 with the value 2"
  program[1] = 12;
  program[2] = 2;

  run(&mut program);

  println!("Value at position 0: {}", program[0]);
  Ok(())
}
