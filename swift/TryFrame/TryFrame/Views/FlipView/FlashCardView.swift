//
//  MainView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 8/24/23.
//

import SwiftUI

struct FlashCardView: View {
    @StateObject var state: FlashCardState = FlashCardState(resetViewOnFlip: false)
    @EnvironmentObject var appState: GlobalAppState
    var backgroundColor: Color?
    
    var body: some View {
        let _ = Self._printChanges()
        ZStack {
            TwoSidedFlipView(
                frontView: FlipSideView(contentView: FlashCardQuestionView(flipMethod: flip), isFront: true, bgColor: backgroundColor ?? .gray, flipViewState: state),
                backView: FlipSideView(contentView: FlashCardQuestionView(flipMethod: flip, answerView: true), isFront: false, bgColor: backgroundColor ?? .gray, flipViewState: state),
                allowFlipOnTap: appState.currentQuestion.isOnlyQuestion(),
                cardState: state)
        }
        .onReceive(state.timer, perform: { _ in
            state.clockTick()
        })
    }
    
    func flip() -> Void {
        appState.wasAnswerRevealed = true
        self.state.flip()
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView()
            .environmentObject(GlobalAppState.appStateForPreviewMultichoice())
    }
}
