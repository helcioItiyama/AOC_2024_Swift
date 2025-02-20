import Algorithms

class Matrix {
  var data: [[String]]
  var row = 0
  var col = 0
  let edges = 0
  var sizes = 0
  
  init (_ input: [[String]]) {
    self.data = input
    self.sizes = input.count
    
    for r in 0..<sizes {
      for c in 0..<sizes {
        if data[r][c] == "^" {
          self.row = r
          self.col = c
          break
        }
      }
    }
  }
  
  func checkIfIsBlocked(_ mr: Int, _ mc: Int) -> Bool {
    data[row + mr][col + mc] == "#"
  }
}

struct Day06: AdventDay {
  var data: String

  var entities: [[String]] {
    data
      .split(whereSeparator: \.isNewline)
      .map { $0.map(String.init) }
  }
  
  struct Position: Hashable {
    let x: Int
    let y: Int
  }

  func part1() -> Int {
    let matrix = Matrix(entities)
    var positions = Set<Position>()
    var movHor = -1
    var movVer = 0
    
    while true {
      positions.insert(Position(x: matrix.row, y: matrix.col))
      if matrix.row + movHor < matrix.edges
          || matrix.row + movHor >= matrix.sizes
          || matrix.col + movVer < matrix.edges
          || matrix.col + movVer >= matrix.sizes {
        break
      }
      
      if matrix.checkIfIsBlocked(movHor, movVer) {
        (movHor, movVer) = (movVer, -movHor)
      } else {
        matrix.row += movHor
        matrix.col += movVer
      }
    }

    return positions.count
  }

  func part2() -> Int {
    var count = 0
    let matrix = Matrix(entities)
    
    func guardLoops(_ grid: [[String]], _ r: Int, _ c: Int) -> Bool {
      var movHor = -1
      var movVer = 0
      var nR = r
      var nC = c
      var positions = Set<String>()
      
      while true {
        positions.insert("\(nR),\(nC),\(movHor),\(movVer)")
        
        if nR + movHor < matrix.edges
            || nR + movHor >= matrix.sizes
            || nC + movVer < matrix.edges
            || nC + movVer >= matrix.sizes {
          return false
        }
        
        if grid[nR + movHor][nC + movVer] == "#" {
          (movHor, movVer) = (movVer, -movHor)
        } else {
          nR += movHor
          nC += movVer
        }
        
        if positions.contains("\(nR),\(nC),\(movHor),\(movVer)") {
          return true
        }
      }
    }
    
    for nR in 0..<matrix.sizes {
      for nC in 0..<matrix.sizes {
        if matrix.data[nR][nC] != "." { continue }
        matrix.data[nR][nC] = "#"
        if guardLoops(matrix.data, matrix.row, matrix.col) { count += 1 }
        matrix.data[nR][nC] = "."
      }
    }
    
    return count
  }
}


