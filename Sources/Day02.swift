import Algorithms

struct Day02: AdventDay {
  var data: String

  var entities: [[Int]] {
    data
      .split(separator: "\n")
      .map { $0.split(separator:" ").compactMap { Int($0) }}
  }
  
  func checkIsSafe(_ line: [Int]) -> Bool {
    var isSafe = true
    let isIncreasing = line[1] > line[0]
    for i in 0..<line.count - 1 {
      if isIncreasing {
        let diff = line[i + 1] - line[i]
        if diff > 3 || diff < 1 {
          isSafe = false
          break
        }
      } else {
        let diff = line[i] - line[i + 1]
        if diff > 3 || diff < 1 {
          isSafe = false
          break
        }
      }
    }
    
    return isSafe
  }

  func part1() -> Int {
    var count = 0
    entities.forEach { level in
      let isSafe = checkIsSafe(level)
      if isSafe { count += 1 }
    }
    return count
  }

  func part2() -> Int {
    var count = 0
    entities.forEach { level in
      var isSafe = false
      for i in 0..<level.endIndex {
        let filtered = level
          .enumerated()
          .filter { $0.0 != i }
          .map { $0.1 }
        isSafe = checkIsSafe(filtered)
        if isSafe { break }
      }
      if isSafe { count += 1 }
    }
    return count
  }
}
