//
//  TestView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 8/25/23.
//

import SwiftUI

struct TestView: View {
    @State var count: Double = 0
    @State var angle: Double = 0
    @State var counter: Int = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Count is \(counter)")
        }
        .onReceive(timer, perform: { _ in
            counter += 1
        })
    }
}

struct NameText: View {
    let name: String
    var body: some View {
        HStack (spacing: 0){
            Rectangle()
                .foregroundColor(Color.clear)
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text(name)
                .padding(.leading, 40)
                .frame(maxWidth: .infinity, alignment: .center).foregroundColor(.black).font(.system(size: 20))

        }
        
    }
}

struct SpinWedge: View {
    var text: String
    @State var angle: Double = 285
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Group {
                    Path { path in
                        let center = CGPoint(x: reader.size.width/2, y: reader.size.height/2)
                        path.move(to: center)
                        path.addLine(to: CGPoint(x: center.x, y: reader.size.height/2 - reader.size.width/2 + 2))
                        path.addArc(center: center, radius: reader.size.width/2, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 300), clockwise: false)
                        path.addLine(to: center)
                    }
                    .stroke(.white, lineWidth: 3)
                }
                NameText(name: text).rotationEffect(.degrees(angle), anchor: .center)
            }
        }
    }
}

struct SpinWheelView: View {
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Circle()
                    .fill(.linearGradient(Gradient(colors: [Self.gradientStart, Self.gradientEnd]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.6)))
                    .innerShadow(shape: Circle(), color: .white, lineWidth: 5)
                ForEach(Array(stride(from: 30, to: 390, by: 30)), id: \.self) { idx in
                    SpinWedge(text: "Angle \(idx)").rotationEffect(Angle(degrees: Double(idx)))
                }
            }
        }
        .padding([.leading, .trailing], 30)
    }
}

extension View {
    func move(offsetX: CGFloat, offsetY: CGFloat) -> some View {
        modifier(MyOffsetModifier(offsetX: offsetX, offsetY: offsetY))
    }
}

struct MyOffsetModifier: ViewModifier {
    var offsetX: CGFloat
    var offsetY: CGFloat
    
    func body(content: Content) -> some View {
        content.offset(x: offsetX, y: offsetY)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
