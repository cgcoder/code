//
//  GlobalAppState.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/1/23.
//

import Foundation
import SwiftUI

@MainActor
class GlobalAppState: ObservableObject {
    
    enum ContentMode {
        case shuffled
        case ordered
        case review
        case shuffledReview
    }
    
    @Published var loadedData: String = ""
    @Published var homePageLoadStatus: LoadStatus = .loading
    @Published var flipcardCollections: [FlipCardCollection] = []
    @Published var currentFlipcardCollection: FlipCardCollection? = nil
    @Published var openedContent: FlipCardCollectionContent? = nil
    @Published var shuffledContent: FlipCardCollectionContent? = nil
    @Published var reviewContent: FlipCardCollectionContent? = nil
    @Published var collectionPageLoadStatus: LoadStatus = .loading
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswers: [UInt64:Set<Int32>] = [:]
    @Published var nextQuestionMode: SwipeDirection = .up
    @Published var wasAnswerRevealed: Bool = false
    @Published var collectionStatus: ProgressStatus = .notStarted
    @Published var answerState: Dictionary<UInt64, AnswerStatus> = [:]
    @Published var userSelectedAnswerStatus: AnswerStatus = .skipped // user selected status only for text only questions
    @Published var navigationPath: NavigationPath = NavigationPath()
    @Published var contentMode: ContentMode = .ordered
    
    var currentContent: FlipCardCollectionContent? {
        print("\(self.contentMode)")
        switch self.contentMode {
        case .shuffled:
            return self.shuffledContent
        case .ordered:
            return self.openedContent
        case .review:
            return self.reviewContent
        case .shuffledReview:
            return self.reviewContent
        }
    }
    
    var currentQuestion: FlipCardQuestion {
        return currentContent!.questions[self.currentQuestionIndex]
    }
    
    var wronglyAnsweredCount: Int {
        return self.answerState.filter { state in
            return self.currentContent!.questions.contains(where: {$0.id == state.key}) && (state.value == .wrong || state.value == .partialCorrect)
        }.count
    }
    
    var correctlyAnsweredCount: Int {
        return self.answerState.filter { state in
            return self.currentContent!.questions.contains(where: {$0.id == state.key}) && state.value == .correct
        }.count
    }
    
    var unAnsweredCount: Int {
        return self.answerState.filter { state in
            return self.currentContent!.questions.contains(where: {$0.id == state.key}) && state.value == .skipped
        }.count
    }
    
    func restartCollection() -> Void {
        self.wasAnswerRevealed = false
        self.currentQuestionIndex = 0
        self.collectionStatus = .progress
        self.selectedAnswers.removeAll()
        self.answerState.removeAll()
        self.userSelectedAnswerStatus = .skipped
    }
    
    func startCollection(contentMode: ContentMode) -> Void {
        if contentMode == .shuffledReview {
            // enable shuffle for review
            reviewContent = FlipCardCollectionContent(
                collectionId: self.currentContent!.collectionId,
                questions: self.currentContent!.questions.filter({
                    self.answerState[$0.id] != .correct
                }))
        }
        else if contentMode == .review {
            reviewContent = FlipCardCollectionContent(
                collectionId: self.currentContent!.collectionId,
                questions: self.currentContent!.questions.filter({
                    self.answerState[$0.id] != .correct
                }))
        }
        
        self.contentMode = contentMode
        self.wasAnswerRevealed = false
        self.currentQuestionIndex = 0
        self.collectionStatus = .progress
        self.selectedAnswers.removeAll()
        
        if let reviewQuestions = self.reviewContent?.questions {
            reviewQuestions.forEach { q in
                self.answerState.removeValue(forKey: q.id)
            }
        }
    }
    
    func resetContent() {
        self.openedContent = nil
        self.shuffledContent = nil
        self.reviewContent = nil
    }
    
    func loadPredefinedCollection() -> Void {
        self.homePageLoadStatus = .loading
        Task {
            await loadCollectionIndex(resourceName: "predefinedCollections")
        }
    }
    func loadFlipCardCollection(collectionId: UUID) -> Void {
        if collectionPageLoadStatus == .done && openedContent?.collectionId == collectionId {
            return
        }
        
        self.collectionPageLoadStatus = .loading
        self.resetContent()
        if (collectionId.uuidString.hasPrefix("00000000")) {
            loadFlipCardCollectionInBuilt(collectionId: collectionId)
        }
        else {
            self.collectionPageLoadStatus = .error(message: "Collection not found. Try reinstalling the app.")
        }
        initializeShuffled()
    }
    private func initializeShuffled() -> Void {
        shuffledContent = FlipCardCollectionContent(collectionId: self.openedContent!.collectionId, questions: FlipCardCollectionContent.shuffle(shuffle: true, content: self.openedContent!))
    }
    
    func isCurrentQuestion(id: UInt64) -> Bool {
        return currentContent!.questions[currentQuestionIndex].id == id
    }
    
    func toggleSelectQuestion(_ choiceId: Int32) {
        switch (currentQuestion.choices) {
        case .single:
            selectedAnswers.removeAll()
            break
        default:
            break
        }
        var selectedOptions: Set<Int32> = selectedAnswers[self.currentQuestion.id] ?? []
        
        if selectedOptions.contains(choiceId) {
            selectedOptions.remove(choiceId)
        }
        else {
            selectedOptions.insert(choiceId)
        }
        selectedAnswers[self.currentQuestion.id] = selectedOptions
    }
    
    func setShuffleMode(_ shuffled: Bool) -> Void {
        self.contentMode = shuffled ? .shuffled : .ordered
    }
    
    func resetStateForNext() -> Void {
        self.wasAnswerRevealed = false
    }
    
    func nextQuestion() -> Void {
        recordAnswer()
        resetStateForNext()
        nextQuestionMode = .down
        if (self.currentQuestionIndex >= currentContent!.questions.count-1) {
            self.completeCollection()
        }
        else {
            self.currentQuestionIndex += 1
        }
    }
    
    func prevQuestion() -> Void {
        resetStateForNext()
        nextQuestionMode = .up
        if (self.currentQuestionIndex > 1) {
            self.currentQuestionIndex = (self.currentQuestionIndex - 1)
        }
    }
    
    func recordAnswer() -> Void {
        guard self.answerState.index(forKey: self.currentQuestion.id) == nil else { return }
        
        // for text only questions, user needs to tell us if they guessed the answer correctly or not
        if self.currentQuestion.choices.getTextChoice() != nil {
            let questionId = self.currentQuestion.id
            self.answerState[questionId] = self.userSelectedAnswerStatus
            self.userSelectedAnswerStatus = .skipped
            return
        }
        
            
        let questionId = self.currentQuestion.id
        var result: AnswerStatus = .skipped
        
        if self.currentQuestion.isOnlyQuestion() && !self.wasAnswerRevealed {
            result = .skipped
        }
        let selectedOptions = self.selectedAnswers[self.currentQuestion.id] ?? []
        if self.currentQuestion.isCorrectlyAnswered(selectedIds: selectedOptions) {
            result = .correct
        }
        else if !self.isAnyChoiceSelected() {
            result = .skipped
        }
        else {
            result = .wrong
        }
        
        self.answerState[questionId] = result
    }
    
    func completeCollection() -> Void {
        self.collectionStatus = .complete
    }
    
    func resetCollection() -> Void {
        self.wasAnswerRevealed = false
        self.currentQuestionIndex = 0
        self.collectionStatus = .notStarted
        self.selectedAnswers.removeAll()
        self.answerState.removeAll()
    }
    
    func isSelectedChoice(_ choiceId: Int32) -> Bool {
        let selectedOptions = self.selectedAnswers[self.currentQuestion.id] ?? []
        return selectedOptions.contains(choiceId)
    }
    
    func isAnyChoiceSelected() -> Bool {
        self.selectedAnswers.count != 0
    }
    
    private func loadFlipCardCollectionInBuilt(collectionId: UUID) -> Void {
        
        let id: String = collectionId.uuidString.lowercased()
        
        do {
            if let collection = self.flipcardCollections.first(where: { $0.id == collectionId }) {
                self.currentFlipcardCollection = collection
                
                switch id {
                case "00000000-4b85-4910-b3a5-99f61640afda":
                    load_00000000_4b85_4910_b3a5_99f61640afda(collectionId: collectionId)
                    return
                case "00000000-af40-4b33-b8a8-85d3455a4d43":
                    load_00000000_af40_4b33_b8a8_85d3455a4d43(collectionId: collectionId)
                    return
                case "00000000-5663-4002-83ac-cee5bffcc5da":
                    load_00000000_5663_4002_83ac_cee5bffcc5da(collectionId: collectionId)
                    return
                default:
                    break
                }
                
                if let bundlePath = Bundle.main.path(forResource: collectionId.uuidString.lowercased(), ofType: "json"),
                    let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(FlipCardCollectionContent.self, from: jsonData)
                    self.openedContent = data
                    self.collectionPageLoadStatus = .done
                }
                else {
                    collectionPageLoadStatus = .error(message: "Unable to load. Collection data is corrupt.")
                }
            }
            else {
                collectionPageLoadStatus = .error(message: "This collection is found. Try reinstalling the app.")
            }
        } catch {
            print(error)
            self.collectionPageLoadStatus = .error(message: "Unknown error loading collection.")
        }
    }
    
    private func loadCollectionIndex(resourceName name: String) async -> Void {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let decoder = JSONDecoder()
                let data = try decoder.decode(FlipCardCollectionIndex.self, from: jsonData)
                self.flipcardCollections.append(contentsOf: data.collections)
            }
            homePageLoadStatus = .done
        } catch {
            self.homePageLoadStatus = .error(message: "unable to load flash card collection")
        }
    }
    
    private func load_00000000_4b85_4910_b3a5_99f61640afda(collectionId: UUID) -> Void {
        collectionPageLoadStatus = .done
        var questions: [FlipCardQuestion] = []
        var index = 0
        for i in 1...2 {
            for j in 1...2 {
                questions.append(FlipCardQuestion(id: UInt64(index), text: "\(i) x \(j)", fontSize: .xl, choices: .text(content: "\(i*j)")))
                index += 1
            }
        }
        self.openedContent = FlipCardCollectionContent(collectionId: collectionId, questions: questions)
    }
    
    private func load_00000000_af40_4b33_b8a8_85d3455a4d43(collectionId: UUID) -> Void {
        collectionPageLoadStatus = .done
        var questions: [FlipCardQuestion] = []
        var index = 0
        for i in 6...10 {
            for j in 1...12 {
                questions.append(FlipCardQuestion(id: UInt64(index), text: "\(i) x \(j)", fontSize: .xl, choices: .text(content: "\(i*j)")))
                index += 1
            }
        }
        self.openedContent = FlipCardCollectionContent(collectionId: collectionId, questions: questions)
    }
    
    private func load_00000000_5663_4002_83ac_cee5bffcc5da(collectionId: UUID) -> Void {
        collectionPageLoadStatus = .done
        var questions: [FlipCardQuestion] = []
        var index = 0
        for i in 1...9 {
            for j in 1...9 {
                questions.append(FlipCardQuestion(id: UInt64(index), text: "\(i*10) + \(j)", fontSize: .xl, choices: .text(content: "\(i*10 + j)")))
                index += 1
            }
        }
        self.openedContent = FlipCardCollectionContent(collectionId: collectionId, questions: questions)
    }
}

enum LoadStatus: Equatable {
    case loading
    case longLoading
    case done
    case error(message: String)
}

extension FlipCardQuestion {
    func hasAnswers() -> Bool {
        switch self.choices {
        case .text:
            return false
        default:
            return true
        }
    }
    
    func isCorrectlyAnswered(selectedIds: Set<Int32>) -> Bool {
        switch self.choices {
        case .multi(let options):
            let choiceIds = Set(options.filter({$0.content.isCorrect()}).map({$0.choiceId }))
            return selectedIds == choiceIds && selectedIds.count == choiceIds.count
        case .single(let options):
            let choiceIds = Set(options.filter({$0.content.isCorrect()}).map({$0.choiceId }))
            return selectedIds == choiceIds && selectedIds.count == choiceIds.count
        case .yesNo(let truth):
            return (truth && selectedIds.contains(1)) || (!truth && selectedIds.contains(0))
        default:
            return false
        }
    }
}
