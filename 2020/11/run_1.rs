use std::fs::File;
use std::io::{self, BufRead};

fn main() -> std::io::Result<()> {
  let file = File::open("input")?;
  let mut seats: Vec<Vec<char>> = io::BufReader::new(file).lines().map(|l| l.unwrap().chars().collect()).collect();

  let mut iteration = 1;

  loop {
    //print_seats(iteration, &seats);
    let mut new_seats = Vec::<Vec<char>>::new();

    for y in 0..seats.len() {
      let line = &seats[y];
      let mut new_line = Vec::<char>::new();
      for x in 0..line.len() {
        new_line.push(seat_for(x, y, &seats))
      }
      new_seats.push(new_line);
    }

    if same_seats(&seats, &new_seats) {
      break
    }

    iteration += 1;
    seats = new_seats;
  }

  Ok(())
}

fn seat_for(x: usize, y: usize, seats: &Vec<Vec<char>>) -> char {
  let current_seat = seats[y][x];
  if current_seat == '.' {
    return current_seat
  }

  match adjacent_occupied(x, y, seats) {
    0 => '#',
    4 | 5 | 6 | 7 | 8 | 9 => if current_seat == '#' { 'L' } else { current_seat },
    _ => current_seat
  }
}

fn adjacent_occupied(x: usize, y: usize, seats: &Vec<Vec<char>>) -> u32 {
  let width = seats[0].len();
  let mut result = 0;

  if y > 0 {
    if x > 0 {
      result += occupied(x-1, y-1, seats);
    }
    result += occupied(x, y-1, seats);
    if x < width-1 {
      result += occupied(x+1, y-1, seats);
    }
  }

  if x > 0 {
    result += occupied(x-1, y, seats);
  }
  if x < width-1 {
    result += occupied(x+1, y, seats);
  }

  if y < seats.len() - 1 {
    if x > 0 {
      result += occupied(x-1, y+1, seats);
    }
    result += occupied(x, y+1, seats);
    if x < width-1 {
      result += occupied(x+1, y+1, seats);
    }
  }

  result
}

fn occupied(x: usize, y: usize, seats: &Vec<Vec<char>>) -> u32 {
  if seats[y][x] == '#' {
    1
  } else {
    0
  }
}

fn same_seats(seats1: &Vec<Vec<char>>, seats2: &Vec<Vec<char>>) -> bool {
  for y in 0..seats1.len() {
    for x in 0..seats1[y].len() {
      if seats1[y][x] != seats2[y][x] {
        return false
      }
    }
  }
  true
}

fn print_seats(iteration: u32, seats: &Vec<Vec<char>>) {
  println!("Iteration {}", iteration);
  for line in seats.iter() {
    for c in line.iter() {
      print!("{}", c)
    }
    println!("");
  }
  println!("\n\n");
}