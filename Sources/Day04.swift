import Algorithms

struct Day04: AdventDay {
  var data: String

  var entities: [[String]] {
    data
      .split(whereSeparator: \.isWhitespace )
      .map { $0.map(String.init) }
  }

  func part1() -> Int {
    var count = 0
    
    for r in entities.indices {
      for c in entities[0].indices {
        if entities[r][c] != "X" { continue }
        
        for dr in [-1, 0, 1] {
          for dc in [-1, 0, 1] {
            if dr == 0 && dc == 0 { continue }
            
            let positions = [
              (r + dr, c + dc),
              (r + 2 * dr, c + 2 * dc),
              (r + 3 * dr, c + 3 * dc)
            ]
            
            let isWithinBorders = 0 <= positions[2].0
              && positions[2].0 < entities.count
              && 0 <= positions[2].1
              && positions[2].1 < entities[0].count
            
            if isWithinBorders && entities[positions[0].0][positions[0].1] == "M"
              && entities[positions[1].0][positions[1].1] == "A"
              && entities[positions[2].0][positions[2].1] == "S" {
                count += 1
            }
          }
        }
      }
    }
    return count
  }

  func part2() -> Int {
    var count = 0
    for r in 1..<entities.count - 1 {
      for c in 1..<entities[0].count - 1 {
        if entities[r][c] != "A" { continue }
        
        let corners = [
          entities[r - 1][c - 1],
          entities[r - 1][c + 1],
          entities[r + 1][c + 1],
          entities[r + 1][c - 1],
        ]
        
        let allowedFormations = ["MMSS", "MSSM", "SSMM", "SMMS"]
        let formations = corners.joined(separator: "")
        
        if allowedFormations.contains(formations) { count += 1 }
      }
    }
    return count
  }
}
