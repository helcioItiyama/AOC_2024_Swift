import Algorithms

struct Day25: AdventDay {
  var data: String

  var entities: [[String]] {
    var temp = [String]()
    return data.split(whereSeparator: \.isNewline)
      .enumerated()
      .reduce(into: [[String]]()) { acc, curr in
        let (i, elem) = curr
        temp.append(String(elem))
        if (i + 1) % 7 == 0 {
          acc.append(temp)
          temp.removeAll()
        }
      }
  }
  
  func getHeights(_ list: [[String]]) -> [[Int]] {
    return list.map {
      var invertedList: [[String]] = Array(
        repeating: Array(repeating: "", count: list[0].count),
        count: list[0][0].count
      )
      
      for r in 0..<$0.count {
        for c in 0..<$0[0].count {
          let index = $0[r].index($0[r].startIndex, offsetBy: c)
          invertedList[c][r] = String($0[r][index])
        }
      }
      
      return invertedList.map { $0.count { $0 == "#" } - 1 }
    }
  }

  func part1() -> Int {
    let (keys, locks) = entities.partitioned {
      $0.first?.count(where: { c in c == "#"}) == $0.first?.count
    }
    
    let locksCoords = getHeights(locks)
    let keyCoords = getHeights(keys)
    var count = 0
    
    for lock in locksCoords {
      for key in keyCoords {
        var isTrue = [Bool]()
        for i in lock.indices {
          isTrue.append(lock[i] + key[i] <= locksCoords[0].count)
        }
        if isTrue.allSatisfy(\.self) { count += 1 }
      }
    }
    
    return count
  }

  func part2() -> Int {
    0
  }
}

