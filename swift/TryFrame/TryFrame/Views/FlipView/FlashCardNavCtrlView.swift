//
//  FlashCardNavCtrlView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/23/23.
//

import SwiftUI

struct FlashCardNavCtrlView: View {
    @EnvironmentObject var appState: GlobalAppState
    var answerView: Bool
    var flipMethod: (() -> Void)?
    var body: some View {
        HStack {
            Spacer()
            Button() {
                withAnimation {
                    appState.prevQuestion()
                }
            } label: {
                Image(systemName: "backward.fill")
            }
            .padding(15)
            .foregroundColor(.white)
            .buttonStyle(NeumorphicButtonStyle(bgColor: appState.currentQuestionIndex == 0 ? .gray : .orange))
            .disabled(appState.currentQuestionIndex == 0)
            
            Spacer()
            
            flipButton()
                .foregroundColor(.white)
                .buttonStyle(NeumorphicButtonStyle(bgColor: .green))
            
            Spacer()
            
            Button() {
                withAnimation {
                    appState.nextQuestion()
                }
            } label: {
                Image(systemName: "forward.fill")
            }
            .padding(15)
            .foregroundColor(.white)
            .buttonStyle(NeumorphicButtonStyle(bgColor: .red))
            Spacer()
        }
    }
    
    func flipButton() -> some View {
        var image = "checkmark.circle.fill"
        
        if (!answerView && appState.wasAnswerRevealed) {
            image = "book.closed.fill"
        }
        
        return Button() {
            withAnimation {
                flipMethod?()
            }
        } label: {
            Image(systemName: image)
        }
        .padding(15)
        // .background(appState.wasAnswerRevealed && !answerView ? .blue : .green)
    }
}

#Preview {
    FlashCardNavCtrlView(answerView: false)
}
