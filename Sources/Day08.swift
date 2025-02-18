import Algorithms

// This code is based on HyperNeutrino's

struct Positions: Hashable {
  let x: Int
  let y: Int
}

struct Day08: AdventDay {
  var data: String

  var entities: [[String]] {
    data
      .split(separator: "\n")
      .map { line in line.split(separator: "").map(String.init) }
  }
  
  var antennas: [String: [(Int, Int)]] {
    var antennas: [String: [(Int, Int)]] = [:]
    
    for (r, row) in entities.enumerated() {
      for (c, char) in row.enumerated() {
        let str = String(char)
        if str != "." {
          antennas[str, default: []].append((r, c))
        }
      }
    }
    
    return antennas
  }
  
  func part1() -> Int {
    var antinodes = Set<Positions>()
    
    for arr in antennas.values {
      for i in 0..<arr.endIndex {
        for j in (i + 1)..<arr.endIndex {
          let (r1, c1) = arr[i]
          let (r2, c2) = arr[j]
          antinodes.insert(Positions(x: 2 * r1 - r2, y: 2 * c1 - c2))
          antinodes.insert(Positions(x: 2 * r2 - r1, y: 2 * c2 - c1))
        }
      }
    }
    
    return antinodes
      .filter { 0 <= $0.x && $0.x < entities.count && 0 <= $0.y && $0.y < entities[0].count }
      .count
  }

  func part2() -> Int {
    var antinodes = Set<Positions>()
    
    for arr in antennas.values {
      for i in 0..<arr.endIndex {
        for j in 0..<arr.endIndex {
          if i == j { continue }
          let (r1, c1) = arr[i]
          let (r2, c2) = arr[j]
          let dr = r2 - r1
          let dc = c2 - c1
          var r = r1
          var c = c1
          while 0 <= r && r < entities.count && 0 <= c && c < entities[0].count {
            antinodes.insert(Positions(x: r, y: c))
            r += dr
            c += dc
          }
        }
      }
    }
    
    return antinodes.count
  }
}


