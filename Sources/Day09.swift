import Algorithms

struct Day09: AdventDay {
  var data: String

  var entities: [[String]] {
    data.split(whereSeparator: \.isNewline).map { $0.map(String.init) }
  }
  
  func part1() -> Int {
    var id = 0
    
    var list: [String] = entities.reduce(into: []) { acc, curr in
      curr.enumerated().forEach { i, num in
        if i % 2 == 0 {
          var e = 1
          while e <= Int(num) ?? 0 {
            acc.append(String(id))
            e += 1
          }
          id += 1
        } else {
          var e = 1
          while e <= Int(num) ?? 0 {
            acc.append(".")
            e += 1
          }
        }
      }
    }
    
    var leftIndex = 0
    var rightIndex = list.count - 1
    
    while leftIndex < rightIndex {
      if list[leftIndex] != "." {
        leftIndex += 1
      } else if list[rightIndex] != "." {
        (list[leftIndex], list[rightIndex]) = (list[rightIndex], list[leftIndex])
        leftIndex += 1
        rightIndex -= 1
      } else {
        rightIndex -= 1
      }
    }
    
    return list.enumerated().reduce(into: 0) { acc, curr in
      if curr.element != "." {
        acc += curr.offset * (Int(curr.element) ?? 1)
      }
    }
  }

  func part2() -> Int {
    var id = 0
    var pos = 0
    var sum = 0
    
    var (block, list): ([Int: [Int]], [[Int]]) = entities.reduce(into: ([:], [])) { acc, curr in
      curr.enumerated().forEach { i, n in
        let num = Int(n) ?? 0
        if i % 2 == 0 {
          acc.0[id] = [pos, num]
          pos += num
          id += 1
        } else if num != 0 {
          acc.1.append([pos, num])
          pos += num
        }
      }
    }
    
    for i in stride(from: block.count - 1, through: 0, by: -1) {
      for j in 0..<list.count {
        if block[i]![0] > list[j][0] {
          if block[i]![1] <= list[j][1] {
            block[i]![0] = list[j][0]
            list[j][0] += block[i]![1]
            list[j][1] -= block[i]![1]
            if list[j][1] == 0 { list.remove(at: j) }
            break
          }
        }
      }
    }
    
    block.forEach { key, value in
      for i in value[0]..<(value[1] + value[0]) {
        sum += key * i
      }
    }
    
    return sum
  }
}



