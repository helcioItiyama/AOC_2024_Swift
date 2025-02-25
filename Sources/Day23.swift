import Algorithms

struct Day23: AdventDay {
  var data: String

  var entities: [String: Set<String>] {
    data
      .split(whereSeparator: \.isNewline)
      .reduce(into: [String: Set<String>]()) { acc, curr in
          let split = curr.split(separator: "-").map(String.init)
          acc[split[0], default: Set<String>()].insert(split[1])
          acc[split[1], default: Set<String>()].insert(split[0])
        }
  }

  func part1() -> String {
    func traverse(_ key: String) -> Set<[String]>? {
      entities[key]?.reduce(into: Set<[String]>()) { acc, curr in
        let matchedKey = entities[curr, default: Set<String>()].filter { entities[key]?.contains($0) == true }
        matchedKey.forEach { k in
          let kHasT = k.starts(with: "t")
          let hasKeyT = key.starts(with: "t")
          let hasValueT = curr.starts(with: "t")
          let hasAnyKeyT = hasKeyT || hasValueT || kHasT
          if hasAnyKeyT { acc.insert([key, curr, k].sorted()) }
        }
      }
    }
    
    return String(entities.keys.reduce(into: Set<[String]>()) { acc, curr in
      if let each = traverse(curr) {
        each.forEach { acc.insert($0) }
      }
    }.count)
  }

  func part2() -> String {
    var connections = Set<Set<String>>()
    
    func traverse(_ key: String, _ set: Set<String>) {
      let setKeys = Set(set.sorted())
      if connections.contains(setKeys) { return }
      connections.insert(setKeys)
      
      for each in entities[key, default: Set<String>()] {
        if set.contains(each) { continue }
        if !set.allSatisfy({ k in entities[k, default: Set<String>()].contains(each) }) { continue }
        var copy = set
        copy.insert(each)
        traverse(each, copy)
      }
    }
    
    entities.keys.forEach { traverse($0, Set(arrayLiteral: $0)) }
    
    return connections.max(by: { $0.count < $1.count })?.sorted().joined(separator: ",") ?? ""
  }
}

