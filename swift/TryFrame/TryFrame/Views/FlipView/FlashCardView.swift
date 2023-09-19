//
//  MainView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 8/24/23.
//

import SwiftUI

struct FlashCardView: View {
    @StateObject var state: FlashCardState = FlashCardState(resetViewOnFlip: false)
    
    var question: FlipCardQuestion
    
    var body: some View {
        ZStack {
            TwoSidedFlipView(
                frontView: FlipSideView(contentView: FlashCardQuestionView(flipMethod: state.flip), isFront: true, flipViewState: state),
                backView: FlipSideView(contentView: FlashCardAnswerView(question: question), isFront: false, flipViewState: state),
                cardState: state)
        }.onAppear {
            state.animateProgress()
        }
        .onReceive(state.timer, perform: { _ in
            state.clockTick()
        })
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView(question: FlipCardQuestion.sampleTextQuestion(id: 1))
    }
}
