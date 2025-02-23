struct PriorityQueue {
    private var heap: [[Int]]
    private let areSorted: ([Int], [Int]) -> Bool

    init(sort: @escaping ([Int], [Int]) -> Bool) {
        self.heap = []
        self.areSorted = sort
    }

    var isEmpty: Bool {
        return heap.isEmpty
    }

    var count: Int {
        return heap.count
    }

    func peek() -> [Int]? {
        return heap.first
    }

    mutating func enqueue(_ element: [Int]) {
        heap.append(element)
        siftUp(from: heap.count - 1)
    }

    mutating func dequeue() -> [Int]? {
        guard !heap.isEmpty else { return nil }
        if heap.count == 1 { return heap.removeLast() }
        heap.swapAt(0, heap.count - 1)
        let removed = heap.removeLast()
        siftDown(from: 0)
        return removed
    }

    private mutating func siftUp(from index: Int) {
        var child = index
        var parent = (child - 1) / 2
        while child > 0 && areSorted(heap[child], heap[parent]) {
            heap.swapAt(child, parent)
            child = parent
            parent = (child - 1) / 2
        }
    }

    private mutating func siftDown(from index: Int) {
        var parent = index
        let count = heap.count
        while true {
            let left = 2 * parent + 1
            let right = 2 * parent + 2
            var candidate = parent

            if left < count && areSorted(heap[left], heap[candidate]) {
                candidate = left
            }
            if right < count && areSorted(heap[right], heap[candidate]) {
                candidate = right
            }
            if candidate == parent { return }
            heap.swapAt(parent, candidate)
            parent = candidate
        }
    }
}

