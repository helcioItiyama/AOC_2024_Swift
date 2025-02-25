import Algorithms

struct Day22: AdventDay {
  var data: String

  var entities: [String] {
    data.split(whereSeparator: \.isNewline).map(String.init)
  }

  func part1() -> Int {
    func mix(_ v: Int, _ secret: Int) -> Int { v ^ secret }
    
    func prune(_ v: Int) -> Int { v % 16777216 }
    
    let result = entities.map {
      var i = 1
      var secret = Int($0) ?? 1
      
      while i <= 2000 {
        secret = prune(mix(secret * 64, secret))
        secret = prune(mix(secret / 32, secret))
        secret = prune(mix(secret * 2048, secret))
        i += 1
      }
      return secret
    }
    
    return result.reduce(0, +)
  }

  func part2() -> Int {
    0
  }
}

