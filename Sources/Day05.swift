import Algorithms
import RegexBuilder

struct Day05: AdventDay {
  var data: String

  var entities: ([Int: [Int]], [[Int]]) {
    let pattern = try! Regex(#"\d+\|\d+"#)
    let lines = data.split(whereSeparator: \.isNewline).map(String.init)
    
    let (left, right) = lines.partitioned(by: { $0.wholeMatch(of: pattern) == nil })
    
    let rules: [Int: [Int]] = left.reduce(into: [:]) { acc, curr in
      let arr = curr.split(separator: "|").compactMap { Int($0) }
      acc[arr[0], default: []].append(arr[1])
    }
    
    let orders = right.map { $0.split(separator: ",").compactMap { Int($0) } }
 
    return (rules, orders)
  }
  
  func checkIfIsCorrect(_ arr: [Int], _ rules: [Int: [Int]]) -> Bool {
    arr.enumerated().allSatisfy { index, value in
      if index == 0 { return true }
      return rules[value, default: []].contains(arr[index - 1])
    }
  }

  func part1() -> Int {
    let (rules, orders) = entities
    return orders.filter {
      let reversed = $0.reversed().map { Int($0) }
      return checkIfIsCorrect(reversed, rules)
    }.reduce(0) { acc, curr in
      let i = Int((Double(curr.count) / 2).rounded(.down))
      return acc + curr[i]
    }
  }

  func part2() -> Int {
    let (rules, orders) = entities
    return orders.reduce(0) { acc, curr in
      var reversed = curr.reversed().map { Int($0) }
      let isTrue = checkIfIsCorrect(reversed, rules)
      var sum = 0
      if !isTrue {
        for i in 1..<reversed.endIndex {
          var j = i - 1
          let curr = reversed[i]
          while j >= 0 && rules[curr]?.contains(reversed[j]) == false {
            reversed[j + 1] = reversed[j]
            j -= 1
          }
          reversed[j + 1] = curr
        }
        sum += reversed[Int((Double(reversed.count) / 2).rounded(.down))]
      }
      return acc + sum
    }
  }
}

