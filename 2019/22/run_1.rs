use std::fs::File;
use std::io::{self, BufRead};

fn main() -> std::io::Result<()> {
  let file = File::open("22/input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();

  let mut deck = vec![];
  for i in 0..10007 {
    deck.push(i);
  }

  for command in lines.iter() {
    if command.starts_with("deal into new stack") {
      println!("Dealing into new stack");
      deck = deal_into_new_stack(deck);
    } else if command.starts_with("cut ") {
      let cut_at: i32 = command[4..].parse().unwrap();
      println!("Cutting {}", cut_at);
      deck = cut(deck, cut_at);
    } else if command.starts_with("deal with increment ") {
      let increment: usize = command[20..].parse().unwrap();
      println!("Dealing with increment {}", increment);
      deck = deal_with_increment(deck, increment);
    } else {
      panic!("Unknown command: '{}'", command);
    }
  }

  println!("Position of card 2019: {}", deck.iter().position(|&card| card == 2019).unwrap());

  Ok(())
}

fn deal_into_new_stack(mut deck: Vec<usize>) -> Vec<usize> {
  deck.reverse();
  deck
}

fn cut(deck: Vec<usize>, cut_at: i32) -> Vec<usize> {
  let mut result = vec![];
  for i in 0..deck.len() {
    result.push(deck[((i as i32 + cut_at + deck.len() as i32) % deck.len() as i32) as usize]);
  }
  result
}

fn deal_with_increment(deck: Vec<usize>, increment: usize) -> Vec<usize> {
  let mut result = vec![];
  // Populate with pure 0s
  for _ in 0..deck.len() {
    result.push(0);
  }
  let mut position = 0;
  for i in 0..deck.len() {
    result[position % deck.len()] = deck[i];
    position += increment;
  }
  result
}