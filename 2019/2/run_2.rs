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
  let file = File::open("2/input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let original_program: Vec<usize> = lines.iter()
    .flat_map(|line| line.split(',').map(|intcode_as_string| intcode_as_string.parse::<usize>().unwrap()))
    .collect();

  for noun in 0..99 {
    for verb in 0..99 {
      let mut program = original_program.clone();
      program[1] = noun;
      program[2] = verb;
      run(&mut program);
      if program[0] == 19690720 {
        println!("Answer: 100 * {} + {} = {}", noun, verb, 100 * noun + verb);
        return Ok(());
      }
    }
  }

  panic!("No nouns or verbs generate the desired output");
}
