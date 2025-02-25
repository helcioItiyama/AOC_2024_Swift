import Algorithms

struct Day20: AdventDay {
  var data: String

  var entities: [[String]] {
    data.split(whereSeparator: \.isNewline ).map { $0.map(String.init)}
  }
  
  struct Positions: Hashable {
    let x: Int
    let y: Int
  }
  
  struct Matrix {
    var matrix = [[String]]()
    private var r = 0
    private var c = 0
    let edge = 0
    var size = 0
    var distances = [[Int]]()
    
    init(_ entities: [[String]]) {
      matrix = entities
      size = entities.count - 1
      distances = Array(repeating: Array(repeating: -1, count: size + 1), count: size + 1)
      
      outerLoop: for row in edge...size {
        for col in edge...size {
          if matrix[row][col] == "S" {
            r = row
            c = col
            break outerLoop
          }
        }
      }
      
      distances[r][c] = 0
      
      while matrix[r][c] != "E" {
        let directions = [(r - 1, c), (r, c + 1), (r + 1, c), (r, c - 1)]
        for (nr, nc) in directions {
          if checkEdges(nr, nc) { continue }
          if checkIfItsWall(nr, nc) { continue }
          if distances[nr][nc] != -1 { continue }
          distances[nr][nc] = distances[r][c] + 1
          r = nr
          c = nc
        }
      }
    }
    
    func checkIfItsWall(_ r: Int, _ c: Int) -> Bool {
      matrix[r][c] == "#"
    }
    
    func checkEdges(_ r: Int, _ c: Int) -> Bool {
      r < edge || r >= size || c < edge || c >= size
    }
    
    func calculateDistance(_ initRow: Int, _ initCol: Int, _ finalRow: Int, _ finalCol: Int) -> Int {
      distances[initRow][initCol] - distances[finalRow][finalCol]
    }
  
  }

  func part1() -> Int {
    let matrix = Matrix(entities)
    var count = 0
    
    for row in matrix.edge...matrix.size {
      for col in matrix.edge...matrix.size {
        if matrix.checkIfItsWall(row, col) { continue }
        let possibleDir = [(row + 2, col), (row + 1, col + 1), (row, col + 2), (row - 1, col + 1 )]
        for (nr, nc) in possibleDir {
          if matrix.checkEdges(nr, nc) { continue }
          if matrix.checkIfItsWall(nr, nc) { continue }
          if abs(matrix.calculateDistance(row, col, nr, nc)) >= 102 {
            count += 1
          }
        }
      }
    }
    return count
  }

  func part2() -> Int {
    let matrix = Matrix(entities)
    var count = 0
    
    for row in matrix.edge...matrix.size {
      for col in matrix.edge...matrix.size {
        if matrix.checkIfItsWall(row, col) { continue }
        for radius in 2...20 {
          for dr in 0...radius {
            let dc = radius - dr
            let possibleDir: Set<Positions> = [
              Positions(x: row + dr, y: col + dc),
              Positions(x: row + dr, y: col - dc),
              Positions(x: row - dr, y: col + dc),
              Positions(x: row - dr, y: col - dc)
            ]
            
            for pos in possibleDir {
              if matrix.checkEdges(pos.x, pos.y) { continue }
              if matrix.checkIfItsWall(pos.x, pos.y) { continue }
              if matrix.calculateDistance(row, col, pos.x, pos.y) >= 100 + radius {
                count += 1
              }
            }
          }
        }
      }
    }
    return count
  }
}

