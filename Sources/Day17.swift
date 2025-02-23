import Algorithms
import Foundation

struct Day17: AdventDay {
  var data: String

  var entities: [[Int]] {
    let numbers = try! Regex(#"\d+"#)
    return data
      .split(whereSeparator: \.isNewline)
      .map { $0.matches(of: numbers).compactMap { Int($0.0) }}
  }

  func part1() -> String {
    var registerA = entities[0][0]
    var registerB = entities[1][0]
    var registerC = entities[2][0]
    let program = entities[3]
    
    var output = [Int]()
    var instructionPointer = 0
    
    func runCombo(_ op: Int) -> Int {
      var type = op
      switch op {
        case 0..<4:
          type = op
          break
        case 4:
          type = registerA
          break
        case 5:
          type = registerB
          break
        case 6:
          type = registerC
          break
        default:
          break
      }
      return type
    }
    
    while instructionPointer < program.count {
      let instruction = program[instructionPointer]
      let operand = program[instructionPointer + 1]
      let combo = runCombo(operand)
      let doubleCombo = Double(combo)
      let adv = Int((Double(registerA) / pow(2.0, doubleCombo)).rounded(.down))
      switch instruction {
        case 0:
          registerA = adv
        case 1:
          registerB ^= operand
        case 2:
          registerB = combo % 8
        case 3:
          if registerA != 0 {
            instructionPointer = operand
            continue
          }
        case 4:
          registerB ^= registerC
        case 5:
          output.append(combo % 8)
        case 6:
          registerB = adv
        case 7:
          registerC = adv
        default:
          print("unknown instruction \(instruction)")
        }
      instructionPointer += 2
    }
    
    return output.map(String.init).joined(separator: ",")
  }

  func part2() -> Int {
    0
  }
}
