//
//  ContentView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 8/24/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ExampleView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ExampleView: View {
    @State private var width: CGFloat = 150
    @State private var fixedSize: Bool = true
    
    var body: some View {
        GeometryReader { proxy in
            
            VStack {
                Spacer()
                
                HStack {
                    LittleSquares(total: 7)
                        .border(Color.green)
                        .fixedSize(horizontal: self.fixedSize, vertical: false)
                }
                .frame(width: self.width)
                .border(Color.primary)
                .background(MyGradient())
                
                Spacer()
                
                Form {
                    Slider(value: self.$width, in: 0...proxy.size.width)
                    Toggle(isOn: self.$fixedSize) { Text("Fixed Width") }
                }
            }
        }.padding(.top, 140)
    }
}

struct LittleSquares: View {
    let sqSize: CGFloat = 20
    let total: Int
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 5) {
                ForEach(0..<self.maxSquares(proxy), id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 5).frame(width: self.sqSize, height: self.sqSize)
                        .foregroundColor(self.allFit(proxy) ? .green : .red)
                }
            }
        }.frame(idealWidth: (5 + self.sqSize) * CGFloat(self.total), maxWidth: (5 + self.sqSize) * CGFloat(self.total))
    }

    func maxSquares(_ proxy: GeometryProxy) -> Int {
        print(proxy.size.width)
        return min(Int(proxy.size.width / (sqSize + 5)), total)
    }
    
    func allFit(_ proxy: GeometryProxy) -> Bool {
        return maxSquares(proxy) == total
    }
}

struct MyGradient: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.1), Color.green.opacity(0.1)]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
    }
}
