import Algorithms

// This code was based on HyperNeutrino's

struct Day12: AdventDay {
  var data: String
  
  struct Position: Hashable {
    let x: Int
    let y: Int
  }
  
  struct DoublesTuple: Hashable {
    let x: Double
    let y: Double
  }

  var entities: [[String]] {
    data
      .split(whereSeparator: \.isNewline)
      .map { $0.map(String.init) }
  }
  
  func part1() -> Int {
    var regions = [Set<Position>]()
    var seen = Set<Position>()
    
    for r in 0..<entities.count {
      for c in 0..<entities[0].count {
        let position = Position(x: r, y: c)
        
        if seen.contains(position) { continue }
        
        seen.insert(position)
        
        var region: Set<Position> = [position]
        var queue: [Position] = [position]
        let crop = entities[r][c]
        
        while !queue.isEmpty {
          let pos = queue.removeFirst()
          for (nr, nc) in [(pos.x - 1, pos.y), (pos.x + 1, pos.y), (pos.x, pos.y - 1), (pos.x, pos.y + 1)] {
            if nr < 0 || nc < 0 || nr >= entities.count || nc >= entities[0].count { continue }
            if entities[nr][nc] != crop { continue }
            let newPosition = Position(x: nr, y: nc)
            if region.contains(newPosition) { continue }
            region.insert(newPosition)
            queue.append(newPosition)
          }
        }
        seen = seen.union(region)
        regions.append(region)
      }
    }
    
    func perimeters(_ reg: Set<Position>) -> Int {
      var output = 0
      
      for r in reg {
        output += 4
        for (nr, nc) in [(r.x + 1, r.y), (r.x - 1 , r.y), (r.x, r.y - 1), (r.x, r.y + 1)] {
          if reg.contains(Position(x: nr, y: nc)) { output -= 1 }
        }
      }
      
      return output
    }
    
    return regions.reduce(0) { acc, curr in acc + curr.count * perimeters(curr) }
  }

  func part2() -> Int {
    var regions = [Set<Position>]()
    var seen = Set<Position>()
    
    for r in entities.indices {
      for c in entities[0].indices {
        let position = Position(x: r, y: c)
        
        if seen.contains(position) { continue }
        
        seen.insert(position)
        
        var region: Set<Position> = [position]
        var queue: [Position] = [position]
        let crop = entities[r][c]
        
        while !queue.isEmpty {
          let pos = queue.removeFirst()
          
          for (nr, nc) in [(pos.x - 1, pos.y), (pos.x + 1, pos.y), (pos.x, pos.y - 1), (pos.x, pos.y + 1)] {
            if nr < 0 || nc < 0 || nr >= entities.count || nc >= entities[0].count { continue }
            if entities[nr][nc] != crop { continue }
            let newPosition = Position(x: nr, y: nc)
            if region.contains(newPosition) { continue }
            region.insert(newPosition)
            queue.append(newPosition)
          }
        }
        seen = seen.union(region)
        regions.append(region)
      }
    }
    
    func getDirections(r: Double, c: Double) -> [DoublesTuple] {
      [
        DoublesTuple(x: r - 0.5, y: c - 0.5),
        DoublesTuple(x: r + 0.5, y: c - 0.5),
        DoublesTuple(x: r + 0.5, y: c + 0.5),
        DoublesTuple(x: r - 0.5, y: c + 0.5)
      ]
    }
    
    func sides(_ region: [DoublesTuple]) -> Int {
      var possibleCorners = Set<DoublesTuple>()
      
      for r in region {
        for each in getDirections(r: r.x, c: r.y) {
          possibleCorners.insert(each)
        }
      }
      
      var corners = 0
      
      for corner in possibleCorners {
        let arrangement = getDirections(r: corner.x, c: corner.y).map { region.contains($0) }
        let number = arrangement.count(where: { $0 == true })
        let isOpposing = arrangement == [true, false, true, false] || arrangement == [false, true, false, true]
        
        if number == 1 || number == 3 {
          corners += 1
        }
        if number == 2 && isOpposing {
          corners += 2
        }
      }
      return corners
    }
    
    return regions.reduce(0) { acc, curr in
      acc + curr.count * sides(curr.map { DoublesTuple(x: Double($0.x), y: Double($0.y)) })
    }
  }
}





