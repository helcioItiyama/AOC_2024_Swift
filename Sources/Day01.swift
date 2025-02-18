import Algorithms

struct Day01: AdventDay {
  var data: String

  var entities: [[Int]] {
    data
        .split(separator: "\n")
        .map { $0.split(separator: "   ").map { Int($0)! } }
        .reduce(into: [[], []]) { acc, current in
          acc[0].append(current[0])
          acc[1].append(current[1])
        }
  }

  func part1() -> Int {
    let initial = entities[0].sorted()
    let final = entities[1].sorted()
    var sum = 0
    initial.enumerated().forEach { i, _ in
      sum += abs(initial[i] - final[i])
    }
    return sum
  }

  func part2() -> Int {
    var sum = 0
    var initial = entities[0].reduce(into: [:]) { acc, curr in acc[curr] = 0 }
    let final = entities[1]
    
    final.forEach {
      if let key = initial[$0] {
        initial[$0] = key + $0
      }
    }
    
    for value in initial.values { sum += value }
    return sum
  }
}
