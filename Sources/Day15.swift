import Algorithms

struct Day15: AdventDay {
  var data: String

  var entities: ([[String]], String) {
    let (instructions, screen) = data
      .split(whereSeparator: \.isNewline)
      .map(String.init)
      .partitioned(by: { String($0).contains("#") })
    let formattedScreen = screen.map { $0.map(String.init) }
    let formattedInstructions = instructions.joined()
    return (formattedScreen, formattedInstructions)
  }

  func part1() -> Int {
    var (screen, instructions) = entities
    var initL = 0
    var initC = 0
    var sum = 0
    
    for l in screen.indices {
      for c in screen[0].indices {
        if screen[l][c] == "@" {
          initL = l
          initC = c
        }
      }
    }
    
    for i in instructions.indices {
      let inst = instructions[i]
      let nextL = inst == "^" ? -1 : inst == "v" ? 1 : 0
      let nextC = inst == "<" ? -1 : inst == ">" ? 1 : 0
      var boxes = [(Int, Int)]()
      var shouldMove = true
      var currentL = initL
      var currentC = initC
      
      while true {
        currentL += nextL
        currentC += nextC
        
        let char = screen[currentL][currentC]
        
        if char == "#" {
          shouldMove = false
          break
        }
     
        if char == "O" {
          boxes.append((currentL, currentC))
        }
        
        if char == "." { break }
      }
      
      if !shouldMove { continue }
      
      screen[initL][initC] = "."
      screen[initL + nextL][initC + nextC] = "@"
      
      for (boxL, boxC) in boxes {
        screen[boxL + nextL][boxC + nextC] = "O"
      }
      
      initL += nextL
      initC += nextC
    }
    
    for i in screen.indices {
      for j in screen[0].indices {
        if screen[i][j] == "O" {
          sum += 100 * i + j
        }
      }
    }
    
    return sum
  }

  func part2() -> Int {
    0
  }
}

