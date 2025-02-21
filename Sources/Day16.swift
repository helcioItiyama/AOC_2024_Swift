import Algorithms

struct Day16: AdventDay {
  var data: String

  var entities: [[String]] {
    data.split(whereSeparator: \.isNewline).map { $0.map(String.init) }
  }

  func part1() -> Int {
    var priorityQueue = PriorityQueue(sort: { $0[0] < $1[0] })
    var c = 0
    var r = 0
    var totalCost = 0
    let forwardPoint = 1
    let rotationPoint = 1000
    
    outerLoop: for row in entities.indices {
      for col in entities[0].indices {
        if entities[row][col] == "S" {
          r = row
          c = col
          break outerLoop
        }
      }
    }
    
    var seen: Set<[Int]> = [[r, c, 0, 1]]
    priorityQueue.enqueue([0, r, c, 0, 1])
    
    while !priorityQueue.isEmpty {
      guard let queue = priorityQueue.dequeue() else { break }
      let cost = queue[0]
      let currR = queue[1]
      let currC = queue[2]
      let directionR = queue[3]
      let directionC = queue[4]
        
      seen.insert([currR, currC, directionR, directionC])
      
      if entities[currR][currC] == "E" {
        totalCost = cost
        break
      }
      
      let paths = [
        [cost + forwardPoint, currR + directionR, currC + directionC, directionR, directionC],
        [cost + rotationPoint, currR, currC, directionC, -directionR],
        [cost + rotationPoint, currR, currC, -directionC, directionR],
      ]
      
      for path in paths {
        if entities[path[1]][path[2]] == "#" { continue }
        if seen.contains([path[1], path[2], path[3], path[4]]) { continue }
        priorityQueue.enqueue(path)
      }
    }
    
    return totalCost
  }

  func part2() -> Int {
    0
  }
}

