import Algorithms

struct Day11: AdventDay {
  var data: String

  var entities: [Int] {
    data
      .split(whereSeparator: \.isWhitespace)
      .compactMap { Int($0) }
  }
  
  struct Position: Hashable {
    let x: Int
    let y: Int
  }
  
  func part1() -> Int {
    func operation(_ stone: Int, _ i: Int) -> Int {
      if i == 0 { return 1 }
      var results = 0
      
      if stone == 0 {
        results += operation(1, i - 1)
      } else if String(stone).count % 2 == 0 {
        let stringStone = String(stone)
        let half = stringStone.count / 2
        let leading = Int(stringStone.prefix(half)) ?? 0
        let trailing = Int(stringStone.suffix(half)) ?? 0
        results += operation(leading, i - 1) + operation(trailing, i - 1)
      } else {
        results = operation(stone * 2024, i - 1)
      }
      
      return results
    }
    
    return entities.reduce(0) { acc, curr in acc + operation(curr, 25) }
  }

  func part2() -> Int {
    var cache = [Position: Int]()
    
    func operation(_ stone: Int, _ i: Int) -> Int {
      if i == 0 { return 1 }
      
      if !cache.keys.contains(Position(x: stone, y: i)) {
        var results = 0
        
        if stone == 0 {
          results = operation(1, i - 1)
        } else if String(stone).count % 2 == 0 {
          let stringStone = String(stone)
          let half = stringStone.count / 2
          let leading = Int(stringStone.prefix(half)) ?? 0
          let trailing = Int(stringStone.suffix(half)) ?? 0
          results += operation(leading, i - 1) + operation(trailing, i - 1)
        } else {
          results = operation(stone * 2024, i - 1)
        }
        
        cache[Position(x: stone, y: i)] = results
      }
      
      return cache[Position(x: stone, y: i), default: 0]
    }
    
    return entities.reduce(0) { acc, curr in acc + operation(curr, 75) }
  }
}




