//
//  GlobalAppState.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/1/23.
//

import Foundation
import SwiftUI
import CoreData

@MainActor
class GlobalAppState: ObservableObject {
    
    enum ContentMode {
        case shuffled
        case ordered
        case review
        case shuffledReview
    }
    @Published var dbLoadStatus: LoadStatus = .idle
    @Published var dbSaveStatus: LoadStatus = .idle
    @Published var loadedData: String = ""
    @Published var homePageLoadStatus: LoadStatus = .progress
    @Published var flipcardCollections: [FlipCardCollection] = []
    @Published var currentFlipcardCollection: FlipCardCollection? = nil
    @Published var openedContent: FlipCardCollectionContent? = nil
    @Published var shuffledContent: FlipCardCollectionContent? = nil
    @Published var reviewContent: FlipCardCollectionContent? = nil
    @Published var collectionPageLoadStatus: LoadStatus = .progress
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswers: [UInt64:Set<Int32>] = [:]
    @Published var nextQuestionMode: SwipeDirection = .up
    @Published var wasAnswerRevealed: Bool = false
    @Published var collectionStatus: ProgressStatus = .notStarted
    @Published var answerState: Dictionary<UInt64, AnswerStatus> = [:]
    @Published var userSelectedAnswerStatus: AnswerStatus = AnswerStatus(isFrozen: false, correctness: .skipped) // user selected status only for text only questions
    @Published var navigationPath: NavigationPath = NavigationPath()
    @Published var contentMode: ContentMode = .ordered
    @Published var favorites: Set<Favorites> = []
    @Published var recentlyUsed: [RecentlyUsed] = []
    
    var initialized: Bool = false
    let dataContainer = NSPersistentContainer(name: "Model")
    
    var currentContent: FlipCardCollectionContent? {
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
            return self.currentContent!.questions.contains(where: {$0.id == state.key}) && (state.value.correctness == .wrong || state.value.correctness == .partialCorrect)
        }.count
    }
    
    var correctlyAnsweredCount: Int {
        return self.answerState.filter { state in
            return self.currentContent!.questions.contains(where: {$0.id == state.key}) && state.value.correctness == .correct
        }.count
    }
    
    var unAnsweredCount: Int {
        return self.answerState.filter { state in
            return self.currentContent!.questions.contains(where: {$0.id == state.key}) && state.value.correctness == .skipped
        }.count
    }
    
    var favoriteCollections: [FlipCardCollection] {
        self.flipcardCollections.filter { c in
            return self.isFavorite(c.id)
        }
    }
    
    var recentlyUsedCollections: [FlipCardCollection] {
        return self.recentlyUsed.map({ (ru: RecentlyUsed) -> FlipCardCollection? in
            let c = ru.collectionId!
            return flipcardCollections.first(where: { $0.id == c})
        }).filter({ $0 != nil }).map( {$0!})
    }
    
    func initialize() -> Void {
        guard !initialized else { return }
        
        self.loadPredefinedCollection()
        self.loadDataFromCoreData()
        self.loadFavorites(context: self.dataContainer.viewContext)
        self.loadRecentlyUsed(context: self.dataContainer.viewContext)
        self.initialized = true
    }
    
    func restartCollection() -> Void {
        self.wasAnswerRevealed = false
        self.currentQuestionIndex = 0
        self.collectionStatus = .progress
        self.selectedAnswers.removeAll()
        self.answerState.removeAll()
        self.userSelectedAnswerStatus = AnswerStatus(isFrozen: false, correctness: .correct)
    }
    
    func startCollection(contentMode: ContentMode) -> Void {
        if contentMode == .shuffledReview {
            // enable shuffle for review
            reviewContent = FlipCardCollectionContent(
                collectionId: self.currentContent!.collectionId,
                questions: self.currentContent!.questions.filter({
                    self.answerState[$0.id]?.correctness != .correct
                }))
        }
        else if contentMode == .review {
            reviewContent = FlipCardCollectionContent(
                collectionId: self.currentContent!.collectionId,
                questions: self.currentContent!.questions.filter({
                    self.answerState[$0.id]?.correctness != .correct
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
        
        self.addToRecentlyUsed(context: self.dataContainer.viewContext, collectionId: self.currentContent!.collectionId)
    }
    
    func resetContent() {
        self.openedContent = nil
        self.shuffledContent = nil
        self.reviewContent = nil
    }
    
    func endCollection() {
        // fake simulate next question actions
        while (self.currentQuestionIndex <= currentContent!.questions.count-1 && self.collectionStatus != .complete) {
            self.nextQuestion()
        }
    }
    
    func loadPredefinedCollection() -> Void {
        self.homePageLoadStatus = .progress
        Task {
            await loadCollectionIndex(resourceName: "predefinedCollections")
        }
    }
    func loadFlipCardCollection(collectionId: UUID) -> Void {
        if collectionPageLoadStatus == .done && openedContent?.collectionId == collectionId {
            return
        }
        
        self.collectionPageLoadStatus = .progress
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
        if (self.currentQuestionIndex >= 1) {
            self.currentQuestionIndex = (self.currentQuestionIndex - 1)
        }
    }
    
    func recordAnswer() -> Void {
        if self.answerState.index(forKey: self.currentQuestion.id) == nil {
            self.answerState[self.currentQuestion.id] = AnswerStatus(isFrozen: false, correctness: .skipped)
        }
        
        guard !self.answerState[self.currentQuestion.id]!.isFrozen else { return }
        
        self.answerState[self.currentQuestion.id]!.isFrozen = self.wasAnswerRevealed
        
        // for text only questions, user needs to tell us if they guessed the answer correctly or not
        if self.currentQuestion.choices.getTextChoice() != nil {
            let questionId = self.currentQuestion.id
            self.answerState[questionId] = self.userSelectedAnswerStatus
            self.userSelectedAnswerStatus = AnswerStatus(isFrozen: false, correctness: .skipped)
            return
        }
        
        let questionId = self.currentQuestion.id
        var result: AnswerStatus = AnswerStatus(isFrozen: false, correctness: .skipped)

        let selectedOptions = self.selectedAnswers[self.currentQuestion.id] ?? []
        if self.currentQuestion.isCorrectlyAnswered(selectedIds: selectedOptions) {
            result.correctness = .correct
        }
        else if !self.isAnyChoiceSelected() {
            result.correctness = .skipped
        }
        else {
            result.correctness = .wrong
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
        if let count = self.selectedAnswers[self.currentQuestion.id]?.count {
            return count > 0
        }
        return false
    }
    
    func isFavorite(_ collectionId: UUID) -> Bool {
        let favorite = self.favorites.first(where: { $0.collectionId == collectionId })
        return favorite != nil
    }
    
    func isRecentlyUsed(_ collectionId: UUID) -> Bool {
        let r = self.recentlyUsed.first(where: { $0.collectionId == collectionId })
        return r != nil
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
    case idle
    case progress
    case longProgress
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
