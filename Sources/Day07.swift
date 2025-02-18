import Algorithms

typealias Callback = (_ target: Int, _ operators: [Int]) -> Bool

struct Day07: AdventDay {
  var data: String

  var entities: [(String, [Int])] {
    return data
      .split(separator: "\n")
      .map { line in
        let parts = line.split(separator: ":")
        let key = String(parts[0])
        let values = parts[1].split(separator: " ").compactMap{ Int($0) }
        return (key, values)
      }
  }
  
  func getTotal(_ data: [(String, [Int])], _ callback: Callback) -> Int {
    var total = 0
    for (testValue, operatorsValue) in data {
      let target = Int(testValue) ?? 0
      if callback(target, operatorsValue) { total += target }
    }
    return total
  }

  func part1() -> Int {
    func evaluate(_ target: Int, _ arr: [Int]) -> Bool {
      if arr.count == 1 { return target == arr.last }
      if target % arr.last! == 0 && evaluate(target / arr.last!, arr.dropLast()) { return true }
      if target > arr[1] && evaluate(target - arr.last!, arr.dropLast()) { return true }
      return false
    }
    return getTotal(entities, evaluate)
  }

  func part2() -> Int {
    func evaluate(_ target: Int, _ arr: [Int]) -> Bool {
      let targetString = String(target)
      let lastString = String(arr.last!)
      if arr.last != nil { return false }
      if arr.count == 1 { return target == arr.last }
      if target % arr.last! == 0 && evaluate(target / arr.last!, arr.dropLast()) { return true }
      if target > arr[1] && evaluate(target - arr.last!, arr.dropLast()) { return true }
      if targetString.count > lastString.count
          && targetString.hasSuffix(lastString)
          && evaluate(Int(targetString.dropLast(lastString.count)) ?? 0, arr.dropLast()) {
        return true
      }
      return false
    }
    return getTotal(entities, evaluate)
  }
}


