//
//  FlashCardQuestionView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/16/23.
//

import SwiftUI

struct FlashCardQuestionView: View {
    
    var flipMethod: (() -> Void)?
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer()
                QuestionView(question: appState.getCurrentQuestion()).padding(10)
                ChoicesView(question: appState.getCurrentQuestion()).padding(20)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Button("I know") {
                    flipMethod?()
                }
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 5)
                .background(.green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Button("Skip") {
                    flipMethod?()
                }
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 5)
                .background(.orange)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button("I Don't Know") {
                    flipMethod?()
                }
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 5)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
        }
        .padding([.top], 50)
        .padding([.bottom], 10)
    }
}

struct QuestionView: View {
    let question: FlipCardQuestion
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question.text)
                .font(.system(size: CGFloat(question.fontSize.getFontSize())))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ChoicesView: View {
    let question: FlipCardQuestion
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        if let singleChoice = question.choices.getSingleChoices() {
            VStack(alignment: .leading) {
                ForEach(singleChoice, id: \.choiceId) { choice in
                    VStack {
                        SingleChoiceView(choice: choice, selected: false, multiSelect: false)
                    }
                    .padding(5)
                    .background(appState.isSelectedChoice(choice.choiceId) ? .blue : .clear)
                }
            }
        }
        else if let multiChoices = question.choices.getMultiChoices() {
            VStack(alignment: .leading) {
                ForEach(multiChoices, id: \.choiceId) { choice in
                    VStack {
                        SingleChoiceView(choice: choice, selected: false, multiSelect: true)
                    }
                    .padding(5)
                    .background(appState.isSelectedChoice(choice.choiceId) ? .blue : .clear)
                }
            }
        }
    }
}

struct SingleChoiceView: View {
    let choice: ChoiceContent
    let selected: Bool
    let multiSelect: Bool
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        if case let ChoiceContentType.text(text, correct) = choice.content {
            SingleTextChoiceView(choice: choice, text: text, correct: correct)
        }
        else {
            Text("")
        }
    }
}

struct SingleTextChoiceView: View {
    let choice: ChoiceContent
    let text: String
    let correct: Bool
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        Text(text).onTapGesture {
            appState.toggleSelectQuestion(choice.choiceId)
        }
    }
}

struct TextOptions {
    let text: String
    let correct: Bool
}

#Preview {
    FlashCardQuestionView()
        .environmentObject(GlobalAppState.appStateForPreviewMultichoice())
}
