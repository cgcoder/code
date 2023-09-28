//
//  FlashCardQuestionView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/16/23.
//

import SwiftUI

struct FlashCardQuestionView: View {
    
    var flipMethod: (() -> Void)?
    var answerView: Bool = false
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        VStack(alignment: .leading) {
            QuestionPart(question: appState.currentQuestion, answerView: answerView).padding(2)
            if appState.currentQuestion.choices.showOptions() || answerView {
                ChoicesView(question: appState.currentQuestion, answerView: answerView).padding(2)
            }
            
            if (answerView && appState.currentQuestion.choices.getTextChoice() != nil) {
                HStack {
                    Spacer()
                    Button() {
                        appState.userSelectedAnswerStatus = .correct
                    } label: {
                        Image(systemName: "hand.thumbsup")
                    }
                    .padding(15)
                    .foregroundColor(.white)
                    .buttonStyle(NeumorphicButtonStyle(bgColor: appState.userSelectedAnswerStatus == .correct ? .green : .gray))
                    Spacer()
                    Button() {
                        appState.userSelectedAnswerStatus = .wrong
                    } label: {
                        Image(systemName: "hand.thumbsdown")
                    }
                    .padding(15)
                    .foregroundColor(.white)
                    .buttonStyle(NeumorphicButtonStyle(bgColor: appState.userSelectedAnswerStatus == .wrong ? .red : .gray))
                    Spacer()
                }
            }
            
            FlashCardNavCtrlView(answerView: answerView, flipMethod: flipMethod)
        }
        .padding([.top, .bottom])
    }
}

struct QuestionPart: View {
    let question: FlipCardQuestion
    var answerView: Bool = false
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack(alignment: .center) {
                        Text(question.text)
                            .font(.system(size: CGFloat(question.fontSize.getFontSize())))
                            .foregroundColor(.primary)
                        if let image = question.imageUrl {
                            AsyncImage(
                                url: URL(string: image),
                                content: { image in
                                    image.resizable()
                                         .aspectRatio(contentMode: .fit)
                                         .frame(maxWidth: 300, maxHeight: 100)
                                },
                                placeholder: {
                                    ProgressView()
                                }
                            ).frame(width: 200, height: 120)
                        }
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
    }
}

struct ChoicesView: View {
    let question: FlipCardQuestion
    var answerView: Bool = false
    @EnvironmentObject var appState: GlobalAppState

    var body: some View {
        GeometryReader { reader in
            ScrollView(.vertical) {
                if let textChoice = question.choices.getTextChoice() {
                    VStack(alignment: .center) {
                        Text(textChoice).foregroundColor(Color("QuestionColor"))
                            .font(.system(size: CGFloat(question.fontSize.getFontSize())))
                    }
                    .frame(width: reader.size.width)
                    .frame(minHeight: reader.size.height)
                }
                else if let singleChoice = question.choices.getSingleChoices() {
                    VStack(alignment: .leading) {
                        ForEach(singleChoice, id: \.choiceId) { choice in
                            VStack {
                                SingleChoiceView(choice: choice, selected: false, multiSelect: false, showAnswer: answerView)
                            }
                            .padding(5)
                            .background(appState.isSelectedChoice(choice.choiceId) ? .blue : .clear)
                            .padding(3)
                            Divider().foregroundStyle(.white)
                        }
                    }
                }
                else if let multiChoices = question.choices.getMultiChoices() {
                    VStack(alignment: .leading) {
                        ForEach(multiChoices, id: \.choiceId) { choice in
                            VStack {
                                SingleChoiceView(choice: choice, selected: false, multiSelect: true, showAnswer: answerView)
                            }
                            .padding(5)
                            .background(appState.isSelectedChoice(choice.choiceId) ? .blue : .clear)
                            .padding(3)
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

struct SingleChoiceView: View {
    let choice: ChoiceContent
    let selected: Bool
    let multiSelect: Bool
    let showAnswer: Bool
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        if case let ChoiceContentType.text(text, correct) = choice.content {
            SingleTextChoiceView(choice: choice, text: text, correct: correct, showAnswer: showAnswer)
        }
        else if case let ChoiceContentType.image(url, correct) = choice.content {
            SingleImageChoiceView(choice: choice, url: url, correct: correct, showAnswer: showAnswer)
        }
        else {
            Text("")
        }
    }
}

struct SingleImageChoiceView: View {
    let choice: ChoiceContent
    let url: String
    let correct: Bool
    let showAnswer: Bool
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        HStack() {
            if (showAnswer) {
                if (correct) {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                }
                else {
                    Image(systemName: "multiply.circle.fill").foregroundColor(.red)
                }
            }
            AsyncImage(
                url: URL(string: self.url),
                content: { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(maxWidth: 300, maxHeight: 100)
                },
                placeholder: {
                    ProgressView()
                }
            ).frame(width: 100, height: 80)
                
        }
        .onTapGesture {
            if (!showAnswer && !appState.wasAnswerRevealed) {
                appState.toggleSelectQuestion(choice.choiceId)
            }
        }
    }
}

struct SingleTextChoiceView: View {
    let choice: ChoiceContent
    let text: String
    let correct: Bool
    let showAnswer: Bool
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        HStack() {
            if (showAnswer) {
                if (correct) {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                }
                else {
                    Image(systemName: "multiply.circle.fill").foregroundColor(.red)
                }
            }
            Text(text).font(.system(size: CGFloat(appState.currentQuestion.fontSize.getFontSize() - 1))).onTapGesture {
                if (!showAnswer && !appState.wasAnswerRevealed) {
                    appState.toggleSelectQuestion(choice.choiceId)
                }
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        }
    }
}

struct TextOptions {
    let text: String
    let correct: Bool
}

extension FlipCardQuestion {
    func questionAlignment() -> Alignment {
        switch self.choices {
        case .text(_):
            return .center
        default:
            return .leading
        }
    }
    
    func isOnlyQuestion() -> Bool {
        switch self.choices {
        case .text(_):
            return true
        default:
            return false
        }
    }
}

#Preview {
    FlashCardQuestionView()
        .environmentObject(GlobalAppState.appStateForPreviewMultichoice())
}
