import Algorithms

struct Day14: AdventDay {
  var data: String

  var entities: [[Int]] {
    let numbers = try! Regex(#"(-)?\d+"#)
    return data
      .split(whereSeparator: \.isNewline)
      .map { $0.matches(of: numbers).compactMap { Int($0.0) }}
  }

  func part1() -> Int {
    let seconds = 100
    let row = 103
    let column = 101
    
    let absModules = entities.map {
      let newXPosition = $0[0] + seconds * $0[2]
      let newYPosition = $0[1] + seconds * $0[3]
      let xAbsModule = (newXPosition % column + column) % column
      let yAbsModule = (newYPosition % row + row) % row
      return (xAbsModule, yAbsModule)
    }
    
    let middlePositions = absModules.filter { (x, y) in
      let isXMiddle = x == Int(Double(column / 2).rounded(.down))
      let isYMiddle = y == Int(Double(row / 2).rounded(.down))
      return !(isXMiddle || isYMiddle)
    }
      
    return middlePositions.reduce(into: [0, 0, 0, 0]) { acc, curr in
      let horizontalHalf = Int(Double((column - 1) / 2).rounded(.down))
      let verticalHalf = Int(Double((row - 1) / 2).rounded(.down))
      
      if curr.0 < horizontalHalf {
        if curr.1 < verticalHalf { acc[0] += 1 } else { acc[2] += 1 }
      } else {
        if curr.1 < verticalHalf { acc[1] += 1} else { acc[3] += 1 }
      }
    }.reduce(1) { acc, i in acc * i }
  }

  func part2() -> Int {
    0
  }
}

