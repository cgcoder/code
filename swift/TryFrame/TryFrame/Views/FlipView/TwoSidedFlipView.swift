//
//  FlipView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 8/25/23.
//

import SwiftUI

protocol FlippableView: View {
}


struct TwoSidedFlipView<FrontView: FlippableView, BackView: FlippableView>: View {
    
    let frontView: FrontView
    let backView: BackView
    let allowFlipOnTap: Bool

    @EnvironmentObject var appState: GlobalAppState
    @ObservedObject var cardState: FlashCardState
    
    var body: some View {
        ZStack() {
            frontView.id(cardState.id)
                .opacity(cardState.showBack ? 0 : 1)
                .rotation3DEffect(Angle.degrees(cardState.showBack ? 180 : 360), axis: (0,1,0))
            backView.id(cardState.id + 1)
                .opacity(cardState.showBack ? 1 : 0)
                .rotation3DEffect(Angle.degrees(cardState.showBack ? 0 : 180), axis: (0,1,0))
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
        .onTapGesture {
            if allowFlipOnTap || cardState.showBack {
                appState.wasAnswerRevealed = true
                cardState.flip()
            }
        }
    }
}
