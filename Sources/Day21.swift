import Algorithms

struct Day21: AdventDay {
  var data: String
  
  struct Positions: Hashable {
    let x: String
    let y: String
  }
  
  struct Directions {
    let r: Int
    let c: Int
    let mov: String
  }
  
  let numKeyPad = [
    ["7", "8", "9"],
    ["4", "5", "6"],
    ["1", "2", "3"],
    [nil, "0", "A"]
  ]
  
  let dirKeyPad = [
    [nil, "^", "A"],
    ["<", "v", ">"]
  ]
  
  func cartesianProduct(_ arr: [[String]]) -> [[String]] {
    arr.reduce([[]]) { acc, curr in
      acc.flatMap { comb in curr.map { comb + [$0] }}
    }
  }

  var entities: [String] {
    data.split(whereSeparator: \.isNewline).map(String.init)
  }

  func part1() -> Int {
    func solve(_ key: String = "", _ keyPad: [[String?]]) -> [String] {
      var pos = [String: (Int, Int)]()
      
      for r in keyPad.indices {
        for c in keyPad[0].indices {
          if let key = keyPad[r][c] { pos[key] = (r, c) }
        }
      }
      
      var seqs = [Positions: [String]]()
      
      for x in pos.keys {
        for y in pos.keys {
          if x == y {
            seqs[Positions(x: x, y: y)] = ["A"]
            continue
          }
          var possibilities = [String]()
          var queue = [(pos[x, default: (0, 0)], "")]
          var optimal = Int.max
          
          whileLoop: while !queue.isEmpty {
            let (pair, moves) = queue.removeFirst()
            let (cr, cc) = pair
            
            let directions = [
              Directions(r: cr - 1, c: cc, mov: "^"),
              Directions(r: cr + 1, c: cc, mov: "v"),
              Directions(r: cr, c: cc - 1, mov: "<"),
              Directions(r: cr, c: cc + 1, mov: ">"),
            ]
            
            for dir in directions {
              if dir.r < 0 || dir.c < 0 || dir.r >= keyPad.count || dir.c >= keyPad[0].count { continue }
              if keyPad[dir.r][dir.c] == nil { continue }
              if keyPad[dir.r][dir.c] == y {
                let movesLength = moves.count + 1
                if optimal < movesLength { break whileLoop }
                optimal = movesLength
                possibilities.append(moves + dir.mov + "A")
              } else {
                queue.append(((dir.r, dir.c), moves + dir.mov))
              }
            }
          }
          seqs[Positions(x: x, y: y)] = possibilities
        }
      }
      
      let options = zip("A\(key)", key).map { (x, y) in seqs[Positions(x: String(x), y: String(y)), default: [""]] }
      return cartesianProduct(options).map { String($0.joined(separator: "")) }
    }
    
    var total = 0
    for line in entities {
      let robot1 = solve(line, numKeyPad)
      var next = robot1
      var count = 0
      repeat {
        var possibleNext = [String]()
        for seq in next {
          possibleNext += solve(seq, dirKeyPad)
        }
        let minLength = possibleNext.compactMap(\.count).min()
        next = possibleNext.filter { $0.count == minLength }
        count += 1
      } while count < 2
      
      total += next[0].count * (Int(line.dropLast()) ?? 1)
    }
    
    return total
  }
  
  struct LengthCache: Hashable {
    let seq: String
    let depth: Int
  }
  
  func computeSeqs(_ keyPad: [[String?]]) -> [Positions: [String]] {
    var pos = [String: (Int, Int)]()
    for r in keyPad.indices {
      for c in keyPad[0].indices {
        if let key = keyPad[r][c] { pos[key] = (r, c) }
      }
    }
    
    var seqs = [Positions: [String]]()
    for x in pos.keys {
      for y in pos.keys {
        if x == y {
          seqs[Positions(x: x, y: y), default:[""]] = ["A"]
          continue
        }
        var possibilities = [String]()
        var queue = [(pos[x, default: (0, 0)], "")]
        var optimal = Int.max
        
        whileLoop: while !queue.isEmpty {
          let (pair, moves) = queue.removeFirst()
          let (cr, cc) = pair
          let directions = [
            Directions(r: cr - 1, c: cc, mov: "^"),
            Directions(r: cr + 1, c: cc, mov: "v"),
            Directions(r: cr, c: cc - 1, mov: "<"),
            Directions(r: cr, c: cc + 1, mov: ">")
          ]
          
          for dir in directions {
            if dir.r < 0 || dir.c < 0 || dir.r >= keyPad.count || dir.c >= keyPad[0].count { continue }
            if keyPad[dir.r][dir.c] == nil { continue }
            if keyPad[dir.r][dir.c] == y {
              let movesLength = moves.count + 1
              if optimal < movesLength { break whileLoop }
              optimal = movesLength
              possibilities.append(moves + dir.mov + "A")
            } else {
              queue.append(((dir.r, dir.c), moves + dir.mov))
            }
          }
        }
        seqs[Positions(x: x, y: y)] = possibilities
      }
    }
    return seqs
  }
  
  func part2() -> Int {
    func solve(_ key: String = "", _ seqs: [Positions: [String]]) -> [String] {
      let options = zip("A\(key)", key).map { (x, y) in seqs[Positions(x: String(x), y: String(y)), default: [""]]}
      return cartesianProduct(options).map { String($0.joined(separator: ""))}
    }
    
    let numSeqs = computeSeqs(numKeyPad)
    let dirSeqs = computeSeqs(dirKeyPad)
    var cache = [LengthCache: Int]()
    
    let dirLengths = Dictionary(uniqueKeysWithValues: dirSeqs.map {($0.key, $0.value.first?.count ?? 0)})
    
    func computeLength(_ seq: String, _ depth: Int = 25) -> Int {
      if depth == 1 {
        return zip("A\(seq)", seq).reduce(0) { acc, curr in
          acc + dirLengths[Positions(x: String(curr.0), y: String(curr.1)), default: 0] }
      }
      
      if !cache.keys.contains(LengthCache(seq: seq, depth: depth)) {
        var length = 0
        for (x, y) in zip("A\(seq)", seq) {
          if let values = dirSeqs[Positions(x: String(x), y: String(y))] {
            length += values.map { computeLength(String($0), depth - 1)}.min() ?? 0 }
        }
        cache[LengthCache(seq: seq, depth: depth)] = length
      }
      return cache[LengthCache(seq: seq, depth: depth), default: 0]
    }
    
    var total = 0
    
    for line in entities {
      let results = solve(line, numSeqs)
      let length = results.map { computeLength($0) }.min() ?? 0
      if let value = Int(line.dropLast()) {
        total += length * value
      }
    }
    return total
  }
}

