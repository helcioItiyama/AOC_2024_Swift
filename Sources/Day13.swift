import Algorithms

struct Day13: AdventDay {
  var data: String

  var entities: [[(Double, Double)]] {
    let numbers = try! Regex(#"\d+"#)
    return data
        .split(whereSeparator: \.isNewline)
        .map {
          let match = $0.matches(of: numbers).compactMap { Double($0.0) }
          return (match[0], match[1])
        }.chunks(ofCount: 3).map(Array.init)
  }
  
  func getCounts(_ game: [(Double, Double)], _ increase: Double = 0.0) -> (Double, Double) {
    let prizeX = game[2].0 + increase
    let prizeY = game[2].1 + increase
    let buttonAx = game[0].0
    let buttonAy = game[0].1
    let buttonBx = game[1].0
    let buttonBy = game[1].1
    let countA = (prizeX * buttonBy - prizeY * buttonBx) / (buttonAx * buttonBy - buttonAy * buttonBx)
    let countB = (prizeX - buttonAx * countA) / buttonBx
    return (countA, countB)
  }

  func part1() -> Int {
    var sum = 0
    
    for entity in entities {
      let (countA, countB) = getCounts(entity)
      print(countA, Int(countA))
      if countA.truncatingRemainder(dividingBy: 1) == 0.0
          && countB.truncatingRemainder(dividingBy: 1) == 0.0 {
        sum += Int(countA * 3 + countB)
      }
    }
    
    return sum
  }

  func part2() -> Int {
    var sum = 0
    for entity in entities {
      let (countA, countB) = getCounts(entity, 10_000_000_000_000)
      if countA.truncatingRemainder(dividingBy: 1) == 0.0
          && countB.truncatingRemainder(dividingBy: 1) == 0.0 {
        sum += Int(countA * 3 + countB)
      }
    }
    return sum
  }
}

