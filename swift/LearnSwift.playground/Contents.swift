protocol Shape {
    func draw() -> String
}

protocol ShapeDrawer {
    associatedtype S: Shape
    func draw(times: Int) -> Void
}

struct Triangle: Shape {
    var size: Int
    
    func draw() -> String {
        var result: [String] = []
        for i in 1...size {
            result.append(String(repeating: "*", count: i))
        }
        
        return result.joined(separator: "\n")
    }
}

struct ConsoleDrawer: ShapeDrawer {
    typealias S = Triangle
    var shape: S
    func draw(times: Int) -> Void {
        for _ in 1...times {
            print(shape.draw())
        }
    }
}

let cd = ConsoleDrawer(shape: Triangle(size: 5))
cd.draw(times: 2);

