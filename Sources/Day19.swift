import Algorithms

struct Day19: AdventDay {
  var data: String

  var entities: ([String], [String]) {
    let res = data.split(whereSeparator: \.isNewline)
    let towels = res[0].split(separator: ", ").map(String.init)
    let patterns = res.dropFirst().map(String.init)
    return (towels, patterns)
  }

  func part1() -> Int {
    let (towels, patterns) = entities
    var cache = [String: Bool]()
    let maxTowelLength = towels.max(by: { $0.count < $1.count })?.count ?? 0
    
    func checkPatterns(_ design: String) -> Bool {
      if cache.keys.contains(design) { return cache[design, default: false] }
      if design == "" { return true }
      
      for i in 1...min(design.count, maxTowelLength) {
        let take = towels.contains(String(design.prefix(i)))
        if take && checkPatterns(String(design.dropFirst(i)))  {
          cache[design] = true
          return true
        }
      }
      cache[design] = false
      return false
    }
    
    return patterns.count { checkPatterns(String($0)) }
  }

  func part2() -> Int {
    var cacheSum = [String: Int]()
    let (towels, patterns) = entities
    let maxTowelLength = towels.max(by: { $0.count < $1.count })?.count ?? 0
    
    func checkOptions(_ design: String) -> Int {
      if cacheSum.keys.contains(design) { return cacheSum[design, default: 0] }
      if design == "" { return 1 }
      var count = 0
      
      for i in 1...min(design.count, maxTowelLength) {
        let hasTowel = towels.contains(String(design.prefix(i)))
        if hasTowel {
          count += checkOptions(String(design.dropFirst(i)))
        }
      }
      cacheSum[design] = count
      return count
    }
    return patterns.reduce(0) { acc, curr in acc + checkOptions(curr) }
  }
}

