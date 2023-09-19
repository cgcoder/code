//
//  FlashCardAnswerView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/16/23.
//

import SwiftUI

struct FlashCardAnswerView: View {
    
    var question: FlipCardQuestion
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            AnswerView(question: question)
            Spacer()
        }
        .padding([.top], 20)
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
    FlashCardAnswerView(question: FlipCardQuestion.sampleTextQuestion(id: 1))
}
