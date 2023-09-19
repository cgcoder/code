//
//  FrontView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 8/25/23.
//

import SwiftUI

struct FlipSideView<ContentView: View>: FlippableView {
    
    
    var contentView: ContentView
    let isFront: Bool
    @ObservedObject var flipViewState: FlashCardState
    
    let linearGradient = LinearGradient(colors: [.gray, .white, .gray], startPoint: .leading, endPoint: .trailing)
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 35)
                .fill(Color("CardColor\(flipViewState.colorOption)").opacity(0.8))
            VStack(alignment: .leading) {
                HStack {
                    contentView
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding([.top], 10)
            .padding([.trailing, .leading], 20)
            .innerShadow(shape: RoundedRectangle(cornerRadius: 35), color: Color.white, lineWidth: 20)
        }
    }
}

struct FlipSideView_Previews: PreviewProvider {
    static var previews: some View {
        FlipSideView(contentView: Text("Hello World!"), isFront: true, flipViewState: FlashCardState())
    }
}
