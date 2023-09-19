//
//  GlobalAppState.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/1/23.
//

import Foundation

@MainActor
class GlobalAppState: ObservableObject {
    
    @Published var loadedData: String = ""
    @Published var homePageLoadStatus: LoadStatus = .loading
    @Published var flipcardCollections: [FlipCardCollection] = []
    @Published var currentFlipCardCollection: FlipCardCollection? = nil
    @Published var currentFlipCardCollectionContent: FlipCardCollectionContent? = nil
    @Published var currentFlipCardCollectionContentShuffled: FlipCardCollectionContent? = nil
    @Published var collectionPageLoadStatus: LoadStatus = .loading
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswers: Set<Int32> = []
    var shuffled: Bool = false
    
    func loadPredefinedCollection() -> Void {
        self.homePageLoadStatus = .loading
        Task {
            await loadCollectionIndex(resourceName: "predefinedCollections")
        }
    }
    func loadFlipCardCollection(collectionId: UUID) -> Void {
        if collectionPageLoadStatus == .done && currentFlipCardCollection?.id == collectionId {
            return
        }
        
        self.collectionPageLoadStatus = .loading
        self.currentFlipCardCollectionContent = nil
        self.currentFlipCardCollectionContentShuffled = nil
        if (collectionId.uuidString.hasPrefix("00000000")) {
            loadFlipCardCollectionInBuilt(collectionId: collectionId)
        }
        else {
            self.collectionPageLoadStatus = .error(message: "Collection not found. Try reinstalling the app.")
        }
        initializeShuffled()
    }
    func initializeShuffled() -> Void {
        guard currentFlipCardCollectionContentShuffled == nil && currentFlipCardCollectionContent != nil else { return }
        currentFlipCardCollectionContentShuffled = FlipCardCollectionContent(collectionId: self.currentFlipCardCollectionContent!.collectionId, questions: FlipCardCollectionContent.shuffle(shuffle: true, content: self.currentFlipCardCollectionContent!))
    }
    
    func isCurrentQuestion(shuffled: Bool, id: UInt64) -> Bool {
        return getQuestions(shuffled: shuffled)[currentQuestionIndex].id == id
    }
    
    func toggleSelectQuestion(_ choiceId: Int32) {
        switch (getCurrentQuestion().choices) {
        case .single:
            selectedAnswers.removeAll()
            break
        default:
            break
        }
        if selectedAnswers.contains(choiceId) {
            selectedAnswers.remove(choiceId)
        }
        else {
            selectedAnswers.insert(choiceId)
        }
    }
    func setShuffleMode(_ shuffled: Bool) -> Void {
        self.shuffled = shuffled
    }
    func getCurrentQuestion() -> FlipCardQuestion {
        return (self.shuffled ? self.currentFlipCardCollectionContentShuffled! : self.currentFlipCardCollectionContent!).questions[self.currentQuestionIndex]
    }
    func getQuestions(shuffled: Bool) -> [FlipCardQuestion] {
        return (shuffled ? self.currentFlipCardCollectionContentShuffled! : self.currentFlipCardCollectionContent!).questions
    }
    func nextQuestion() -> Void {
        self.currentQuestionIndex = (self.currentQuestionIndex + 1) % currentFlipCardCollectionContent!.questions.count
        self.selectedAnswers = []
    }
    func prevQuestion() -> Void {
        self.selectedAnswers = []
        self.currentQuestionIndex = (self.currentQuestionIndex - 1)
        if (self.currentQuestionIndex < 0) {
            self.currentQuestionIndex = currentFlipCardCollectionContent!.questions.count - 1
        }
    }
    func isSelectedChoice(_ choiceId: Int32) -> Bool {
        self.selectedAnswers.contains(choiceId)
    }
    private func loadFlipCardCollectionInBuilt(collectionId: UUID) -> Void {
        
        let id: String = collectionId.uuidString.lowercased()
        
        do {
            if let collection = self.flipcardCollections.first(where: { $0.id == collectionId }) {
                self.currentFlipCardCollection = collection
                
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
                    self.currentFlipCardCollectionContent = data
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
        for i in 1...5 {
            for j in 1...12 {
                questions.append(FlipCardQuestion(id: UInt64(index), text: "\(i) x \(j)", fontSize: .xl, choices: .text(content: "\(i*j)")))
                index += 1
            }
        }
        currentFlipCardCollectionContent = FlipCardCollectionContent(collectionId: collectionId, questions: questions)
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
        currentFlipCardCollectionContent = FlipCardCollectionContent(collectionId: collectionId, questions: questions)
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
        currentFlipCardCollectionContent = FlipCardCollectionContent(collectionId: collectionId, questions: questions)
    }
}

enum LoadStatus: Equatable {
    case loading
    case longLoading
    case done
    case error(message: String)
}
