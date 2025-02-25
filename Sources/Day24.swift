import Algorithms

struct Day24: AdventDay {
  var data: String

  var entities: ([[String]], [String: Bool?]) {
    let (left, right) = data
      .split(whereSeparator: \.isNewline)
      .partitioned(by: { String($0).contains(":") })
    
    let inst = left.map {
      $0.replacing("-> ", with: "").split(whereSeparator: \.isWhitespace).map(String.init)
    }
    
    let valuesHash = right.reduce(into: [String: Bool?]()) { acc, curr in
      let res = curr.split(separator: ": ").map(String.init)
      acc[res[0]] = res[1] == "1"
    }
    
    return (inst, valuesHash)
  }

  func part1() -> Int {
    var (inst, valuesHash) = entities
    var operationHash = [String: [String]]()
    var validOperations = Set<[String]>()
    
    inst.forEach {
      let (v1, op, v2, res) = ($0[0], $0[1], $0[2] ,$0[3])
      if !valuesHash.keys.contains(v1) { valuesHash[v1] = nil }
      if !valuesHash.keys.contains(v2) { valuesHash[v2] = nil }
      if !valuesHash.keys.contains(res) { valuesHash[res] = nil }
      if res.starts(with: "z") { validOperations.insert($0)}
      operationHash[res] = [v1, op, v2]
    }
    
    func runOperation(_ val1: Bool?, _ op: String,_ val2: Bool?) -> Bool? {
      if val1 == nil || val2 == nil { return nil }
      if op == "AND" { return val1! && val2! }
      if op == "OR"  { return val1! || val2! }
      if op == "XOR" { return (val1! ? 1 : 0) ^ (val2! ? 1 : 0) == 1 }
      return nil
    }
    
    func traverse(_ val1: String, _ op: String, _ val2: String) -> Bool? {
      var first: Bool? = nil
      var second: Bool? = nil
      let hashValue1 = valuesHash[val1]
      let hashValue2 = valuesHash[val2]
      
      if let value1 = hashValue1, let value2 = hashValue2{
        return runOperation(value1, op, value2)
      }
      
      if hashValue1 == nil {
        first = traverse(
          operationHash[val1, default: []][0],
          operationHash[val1, default: []][1],
          operationHash[val1, default: []][2]
        )
      }
      
      if hashValue2 == nil {
        second = traverse(
          operationHash[val2, default: []][0],
          operationHash[val2, default: []][1],
          operationHash[val2, default: []][2]
        )
      }
      
      return runOperation(first, op, second)
    }
    
    while validOperations.contains(where: { valuesHash[$0[3]] == nil }) {
      for each in validOperations {
        if valuesHash[each[3]] != nil { continue }
        valuesHash[each[3]] = traverse(each[0], each[1], each[2])
      }
    }
    
    let binary = valuesHash
      .filter { $0.key.starts(with: "z") }
      .sorted { $0.key > $1.key }
      .reduce("") { acc, curr in acc + (curr.value == true ? "1" : "0") }
      
    return Int(binary, radix: 2) ?? 0
  }

  func part2() -> Int {
    0
  }
}

