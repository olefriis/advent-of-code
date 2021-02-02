use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashMap;

type Grid = Vec<Vec<char>>;
fn at(grid: &Grid, position: (i32, i32)) -> usize {
  //println!("Position: {:?}. Grid: {:?}", position, grid);
  match grid[position.1 as usize][position.0 as usize] {
    '#' => 1,
    _ => 0
  }
}

fn total(grid: &Grid) -> usize {
  grid.iter().flat_map(|line| line.iter().collect::<Vec<&char>>()).filter(|&c| c == &'#').count()
}

fn upper(grid: &Grid) -> usize {
  grid[0].iter().filter(|&c| c == &'#').count()
}

fn lower(grid: &Grid) -> usize {
  grid[grid.len()-1].iter().filter(|&c| c == &'#').count()
}

fn left(grid: &Grid) -> usize {
  grid.iter().filter(|line| line.iter().next().unwrap() == &'#').count()
}

fn right(grid: &Grid) -> usize {
  grid.iter().filter(|line| line.iter().last().unwrap() == &'#').count()
}


type RecursiveGrid = HashMap<i32, Grid>;

fn at_recursive(recursive_grid: &RecursiveGrid, dimension: i32, position: (i32, i32)) -> usize {
  match recursive_grid.get(&dimension) {
    Some(grid) => at(&grid, position),
    None => 0,
  }
}

fn neighbours(recursive_grid: &RecursiveGrid, dimension: i32, position: (i32, i32), from: (i32, i32)) -> usize {
  if position.0 == -1 {
    match recursive_grid.get(&(dimension-1)) {
      Some(grid) => at(&grid, (1, 2)),
      None => 0,
    }
  } else if position.0 == 5 {
    match recursive_grid.get(&(dimension-1)) {
      Some(grid) => at(&grid, (3, 2)),
      None => 0,
    }
  } else if position.1 == -1 {
    match recursive_grid.get(&(dimension-1)) {
      Some(grid) => at(&grid, (2, 1)),
      None => 0,
    }
  } else if position.1 == 5 {
    match recursive_grid.get(&(dimension-1)) {
      Some(grid) => at(&grid, (2, 3)),
      None => 0,
    }
  } else if position.0 == 2 && position.1 == 2 {
    if from.0 == 1 {
      match recursive_grid.get(&(dimension+1)) {
        Some(grid) => left(&grid),
        None => 0,
      }
    } else if from.0 == 3 {
      match recursive_grid.get(&(dimension+1)) {
        Some(grid) => right(&grid),
        None => 0,
      }
    } else if from.1 == 1 {
      match recursive_grid.get(&(dimension+1)) {
        Some(grid) => upper(&grid),
        None => 0,
      }
    } else if from.1 == 3 {
      match recursive_grid.get(&(dimension+1)) {
        Some(grid) => lower(&grid),
        None => 0,
      }
    } else {
      panic!("Unexpected...")
    }
  } else {
    match recursive_grid.get(&dimension) {
      Some(grid) => at(&grid, position),
      None => 0,
    }
  }
}

fn main() -> std::io::Result<()> {
  let file = File::open("24/input")?;
  let base_grid: Grid = io::BufReader::new(file).lines().map(|line| line.unwrap().chars().collect()).collect();
  let mut recursive_grid = RecursiveGrid::new();
  recursive_grid.insert(0, base_grid);

  for i in 0..200 {
    println!("Iteration {}", i);

    let mut min = recursive_grid.keys().min().unwrap().clone();
    let mut max = recursive_grid.keys().max().unwrap().clone();

    if total(&recursive_grid.get(&min).unwrap()) > 0 {
      min -= 1;
    }
    if total(&recursive_grid.get(&max).unwrap()) > 0 {
      max += 1;
    }

    let mut new_recursive_grid = HashMap::new();
    for dimension in min..=max {
      let mut grid = Grid::new();
      for y in 0..5 {
        let mut line = vec![];
        for x in 0..5 {
          if x == 2 && y == 2 {
            line.push('.');
          } else {
            let position = (x,y);
            let neighbours = 
              neighbours(&recursive_grid, dimension, (x-1, y), position) +
              neighbours(&recursive_grid, dimension, (x+1, y), position) +
              neighbours(&recursive_grid, dimension, (x, y-1), position) +
              neighbours(&recursive_grid, dimension, (x, y+1), position);
            line.push(
              if at_recursive(&recursive_grid, dimension, position) == 1 {
                if neighbours == 1 { '#' } else { '.' }
              } else {
                if neighbours == 1 || neighbours == 2 { '#' } else { '.' }
              }
            )
          }
        }
        grid.push(line);
      }

      //println!("Inserting at dimension {}: {:?}", dimension, grid);
      new_recursive_grid.insert(dimension, grid);
    }

    recursive_grid = new_recursive_grid;
  }

  let result: usize = recursive_grid.values().map(|grid| total(&grid)).sum();
  println!("Total of {} bugs", result);

  Ok(())
}
