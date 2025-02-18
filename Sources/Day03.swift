import Algorithms
import RegexBuilder

struct Day03: AdventDay {
  var data: String

  var entities: String { data }

  func part1() -> Int {
    let pattern = try! Regex(#"mul\(\d+,\d+\)"#)
    let numbers = try! Regex(#"\d+"#)
    
    return entities
      .matches(of: pattern).map { match in String(match.0) }
      .compactMap { $0.matches(of: numbers).reduce(1) { acc, curr in acc * Int(curr.0)! }}
      .reduce(0) { acc, curr in acc + curr }
  }

  func part2() -> Int {
    let pattern = try! Regex(#"(mul\(\d+,\d+\)|do(n't)?\(\))"#)
    let numbers = try! Regex(#"\d+"#)
    var shouldAdd = true
    
    let filteredMul: [String] = entities
      .matches(of: pattern).map { match in String(match.0) }
      .reduce(into: []) { acc, curr in
        switch curr {
          case "don't()": shouldAdd = false
          case "do()": shouldAdd = true
          default: if shouldAdd { acc.append(curr) }
      }
    }
    
    return filteredMul
      .map { $0.matches(of: numbers).compactMap { Int($0.0) }.reduce(1) { acc, number in acc * number }}
      .reduce(0) { acc, curr in acc + curr }
  }
}
