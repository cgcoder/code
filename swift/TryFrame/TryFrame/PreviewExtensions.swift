//
//  PreviewExtensions.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/17/23.
//

import Foundation


extension FlipCardQuestion {
    static func sampleTextQuestion(id: UInt64) -> FlipCardQuestion {
        return FlipCardQuestion(id: id, text: "2 x 5", fontSize: .xl, choices: .text(content: "10"))
    }
    
    static func sampleSingleChoiceQuestion(id: UInt64) -> FlipCardQuestion {
        return FlipCardQuestion(id: id, text: "What is the capital of India?", fontSize: .lg,
                    choices: .single(options: [
                        ChoiceContent(choiceId: 1, content: .text(text: "New Delhi", correct: true)),
                        ChoiceContent(choiceId: 2, content: .text(text: "Chennai", correct: false)),
                        ChoiceContent(choiceId: 3, content: .text(text: "Mumbai", correct: false)),
                        ChoiceContent(choiceId: 4, content: .text(text: "Lahore", correct: false))
                    ]))
    }
}

extension FlipCardCollection {
    static func sampleFlipCardCollection() -> FlipCardCollection {
        return FlipCardCollection(
            name: "A Sample flip card collection",
            id: UUID(uuidString: "7184ff79-8f91-4dd5-982f-7d005cc703f5")!,
            description: "A flip card collection with a really long text line that you can use.",
            cardColorName: .predefined(name: "CardColor2"))
    }
}

extension GlobalAppState {
    static func appStateForPreview() -> GlobalAppState {
        let appState = GlobalAppState()
        appState.collectionPageLoadStatus = .done
        appState.homePageLoadStatus = .done
        appState.currentFlipCardCollection = FlipCardCollection.sampleFlipCardCollection()
        appState.currentFlipCardCollectionContent = sampleContent(collectionId: appState.currentFlipCardCollection!.id)
        return appState
    }
    
    static func appStateForPreviewMultichoice() -> GlobalAppState {
        let appState = GlobalAppState()
        appState.collectionPageLoadStatus = .done
        appState.homePageLoadStatus = .done
        appState.currentFlipCardCollection = FlipCardCollection.sampleFlipCardCollection()
        appState.currentFlipCardCollectionContent = sampleMultiChoices(collectionId: appState.currentFlipCardCollection!.id)
        return appState
    }
    
    static func sampleContent(collectionId: UUID) -> FlipCardCollectionContent {
        var questions: [FlipCardQuestion] = []
        for i in 1...5 {
            for j in 1...12 {
                questions.append(FlipCardQuestion(id: UInt64(i*j), text: "\(i) x \(j)", fontSize: .xl, choices: .text(content: "\(i*j)")))
            }
        }
        return FlipCardCollectionContent(collectionId: collectionId, questions: questions)
    }
    
    static func sampleMultiChoices(collectionId: UUID) -> FlipCardCollectionContent {
        var questions: [FlipCardQuestion] = []
        questions.append(FlipCardQuestion(id: 1, text: "(1) What is the capital of India?", fontSize: .lg, choices: .multi(options: cityChoicesMulti())))
        questions.append(FlipCardQuestion(id: 2, text: "(2) What is the capital of India?", fontSize: .lg, choices: .multi(options: cityChoices())))
        questions.append(FlipCardQuestion(id: 3, text: "(3) What is the capital of India?", fontSize: .lg, choices: .single(options: cityChoices())))
        return FlipCardCollectionContent(collectionId: collectionId, questions: questions)
    }
    
    static func cityChoices() -> [ChoiceContent] {
        return [ChoiceContent(choiceId: 1, content: .text(text: "New Delhi", correct: true)),
                ChoiceContent(choiceId: 2, content: .text(text: "New Goa", correct: false)),
                ChoiceContent(choiceId: 3, content: .text(text: "Old Delhi", correct: false)),
                ChoiceContent(choiceId: 4, content: .text(text: "New Mumbai", correct: false))]
    }
    
    static func cityChoicesMulti() -> [ChoiceContent] {
        return [ChoiceContent(choiceId: 1, content: .text(text: "New Delhi", correct: true)),
                ChoiceContent(choiceId: 2, content: .text(text: "New Goa", correct: false)),
                ChoiceContent(choiceId: 3, content: .text(text: "Old Delhi", correct: false)),
                ChoiceContent(choiceId: 4, content: .text(text: "Naya Delhi", correct: true))]
    }
}
