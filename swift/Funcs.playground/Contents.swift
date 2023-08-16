import SwiftUI

func double(num: Int) -> Int {
    num * 2
}
print(double(num: 5))
func opDouble(num: Int) -> some Equatable {
    num * 2
}
let eq: some Equatable = opDouble(num: 5)

func printGreeting(name: String, greeter: () -> String) {
    print("\(greeter()) \(name)")
}

struct ContentView: View {
    var body: some View {
        return VStack(content: {
           Image(systemName: "globe")
               .imageScale(.large)
               .foregroundColor(.accentColor)
           Text("Hello, world!")
        })
    }
}

print(ContentView().body)

