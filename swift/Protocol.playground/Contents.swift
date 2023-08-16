
protocol Fuel {
    func burn()
    static func pump() -> Self
}

protocol Startable {
    func start()
    func stop()
}

protocol Vehicle: Startable {
    associatedtype FuelType: Fuel
    init(name: String)
    var name: String { get }
    func fuelUp(fuel: FuelType)
}

struct Gasoline: Fuel {
    func burn() {
        print("burning gas")
    }
    
    static func pump() -> Gasoline {
        return Gasoline()
    }
}

struct Diesel: Fuel {
    func burn() {
        print("burning diesel")
    }
    
    static func pump() -> Diesel {
        return Diesel()
    }
}

struct Car<FuelType: Fuel>: Vehicle {
    init(name: String) {
        self.name = name;
    }
    
    var name: String
    
    func fuelUp(fuel: FuelType) {
        print("Filled with \(type(of: fuel))")
    }
    
    func start() {
        print("\(name) vroom")
    }
    
    func stop() {
        print("\(name) puff")
    }
}

func fillFuel(vehicle: any Vehicle) {
    vehicle.stop()
    vehicle.start()
}

print(5[keyPath: \Int.self])


func sayHello(getName: () -> String, getGreet: () -> String) -> String {
    return "\(getGreet()) \(getName())"
}

let greeting = sayHello {
    "Gopi"
} getGreet: {
    "Mr. "
}

print(greeting)

var s = Student(age: 5)
s.age = 6
print(s.age)

struct Point {
    var x: Int
    var y: Int
    
    init(x: Int) {
        self.x = 5
        self.y = 0
    }
    
    mutating func changeX(t: Int) {
        self.x = t
    }
}

var p = Point(x: 5)
p.x = 1

let t = Point(x:2)

