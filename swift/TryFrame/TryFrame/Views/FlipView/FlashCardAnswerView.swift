//
//  FlashCardAnswerView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/16/23.
//

import SwiftUI

struct FlashCardAnswerView: View {
    
    var flipMethod: (() -> Void)?
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        VStack(alignment: .center) {
            QuestionPart(question: appState.currentQuestion)
            VStack {
                AnswerView(question: appState.currentQuestion)
            }
            .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            FlashCardNavCtrlView(flipMethod: flipMethod)
        }
        .padding([.top, .bottom], 10)
        // .padding([.leading, .trailing], 10)
    }
}

struct AnswerView: View {
    var question: FlipCardQuestion
    
    var body: some View {
        switch question.choices {
        case .text(let content):
            return Text(content).foregroundColor(.white)
                .font(.system(size: CGFloat(question.fontSize.getFontSize())))
        default:
            return Text("")
        }
    }
}

#Preview {
    //FlashCardAnswerView()
      //  .environmentObject(GlobalAppState.appStateForPreviewMultichoice())
    
    FlashCardAnswerView()
        .environmentObject(GlobalAppState.appStateForPreview())
}
