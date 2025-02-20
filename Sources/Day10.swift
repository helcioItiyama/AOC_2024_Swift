import Algorithms

// This code was based on HyperNeutrino's

struct Day10: AdventDay {
  var data: String

  var entities: [[Int]] {
    data
      .split(whereSeparator: \.isNewline)
      .map { $0.compactMap { Int(String($0)) }}
  }
  
  struct Position: Hashable {
    let x: Int
    let y: Int
  }
  
  func part1() -> Int {
    var trailheads = [(Int, Int)]()
    var sum = 0
    
    for r in 0..<entities.count {
      for c in 0..<entities[0].count {
        if entities[r][c] == 0 { trailheads.append((r, c)) }
      }
    }
    
    func score(_ grid: [[Int]], _ r: Int, _ c: Int) -> Int {
      var queue = [(r, c)]
      var summits = Set<Position>()
      while !queue.isEmpty {
        let (cr, cc) = queue.removeFirst()
        for (nr, nc) in [(cr, cc + 1), (cr, cc - 1), (cr + 1, cc), (cr - 1, cc)] {
          if nr < 0 || nc < 0 || nr >= grid.count || nc >= grid[0].count { continue }
          if grid[nr][nc] != grid[cr][cc] + 1 { continue }
          if grid[nr][nc] == 9 {
            summits.insert(Position(x: nr, y: nc))
          } else {
            queue.append((nr, nc))
          }
        }
      }
      return summits.count
    }
    
    for (r, c) in trailheads {
      sum += score(entities, r, c)
    }
    
    return sum
  }

  func part2() -> Int {
    var trailheads = [(Int, Int)]()
    var sum = 0
    
    for r in 0..<entities.count {
      for c in 0..<entities[0].count {
        if entities[r][c] == 0 { trailheads.append((r, c)) }
      }
    }
    
    func score(_ grid: [[Int]], _ r: Int, _ c: Int) -> Int {
      var queue = [(r, c)]
      var traits = 0
      while !queue.isEmpty {
        let (cr, cc) = queue.removeFirst()
        for (nr, nc) in [(cr, cc + 1), (cr, cc - 1), (cr + 1, cc), (cr - 1, cc)] {
          if nr < 0 || nc < 0 || nr >= grid.count || nc >= grid[0].count { continue }
          if grid[nr][nc] != grid[cr][cc] + 1 { continue }
          if grid[nr][nc] == 9 {
            traits += 1
          } else {
            queue.append((nr, nc))
          }
        }
      }
      return traits
    }
    
    for (r, c) in trailheads {
      sum += score(entities, r, c)
    }
    
    return sum
  }
}




