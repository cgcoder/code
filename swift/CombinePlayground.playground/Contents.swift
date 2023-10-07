protocol Animal {
    associatedtype Food
    func sayName()
    func eat(_ food: Food)
}

protocol FoodProvider {
    func getFood<T: Animal>(for animal: T) -> T.Food
}

class StringProvider: FoodProvider {
    func getFood<T>(for animal: T) -> T.Food where T : Animal {
        if (T.Food == String.self) {
            return "string"
        }
        else if (T.Food == Int.self) {
            return 0
        }
    }
}

class IntProvider: FoodProvider {
    func getFood(for animal: Dog) -> Int {
        1
    }
}

class Cow: Animal {
    func sayName() { print("Moo") }
    func eat(_ food: String) {
        print("Cow eating \(food)")
    }
}

class Dog: Animal {
    func sayName() { print("Bow") }
    func eat(_ food: Int) {
        print("Dog eating \(food)")
    }
}

func feedAll(_ animals: [any Animal], provider: FoodProvider) {
    animals.forEach {
        let food = provider.getFood(for: $0)
        feed($0, provider: provider)
    }
}

func feed<T: Animal>(_ animal: T, provider: FoodProvider) {
    let food = provider.getFood(for: animal)
    animal.eat(food)
}

let animals: [any Animal] = [Cow(), Dog()]


