import Algorithms

struct Day18: AdventDay {
  var data: String
  
  struct Position: Hashable {
    let x: Int
    let y: Int
  }

  var entities: (Int, Int, [[String]]) {
    let edge = 0
    let size = 70
    let bytes = 1024
    
    var grid = Array(repeating: Array(repeating: ".", count: size + 1), count: size + 1)
    
    data
      .split(whereSeparator: \.isNewline)
      .map { $0.split(separator: ",").compactMap { Int($0) }}
      .enumerated().forEach { i, each in
        if i < bytes {
          grid[each[0]][each[1]] = "#"
        }
      }
    
    return (edge, size, grid)
  }

  func part1() -> Int {
    let (edge, size, grid) = entities
    var queue = [[0, 0, 0]]
    var hasSeen: Set<Position> = [Position(x: 0, y: 0)]
    var minSteps = 0
    
    while !queue.isEmpty {
      let removed = queue.removeFirst()
      let (row, col, steps) = (removed[0], removed[1], removed[2])
      let directions = [
        Position(x: row + 1, y: col),
        Position(x: row, y: col + 1),
        Position(x: row - 1, y: col),
        Position(x: row, y: col - 1)
      ]
      
      for direction in directions {
        let nextRow = direction.x
        let nextCol = direction.y
      
        if nextRow < edge || nextCol < edge || nextRow > size || nextCol > size { continue }
        if grid[nextRow][nextCol] == "#" { continue }
        if hasSeen.contains(direction) { continue }
        if nextRow == size && nextCol == size {
          minSteps = steps + 1
          break
        }
        hasSeen.insert(direction)
        queue.append([nextRow, nextCol, steps + 1])
      }
      
    }
    return minSteps
  }

  func part2() -> Int {
    0
  }
}

