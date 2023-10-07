//
//  FlipCardCollection.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/1/23.
//

import Foundation
import SwiftUI

enum FlipCardColor: Codable {
    case predefined(name: String)
    case custom(red: Int, blue: Int, green: Int)
}

struct ChoiceContent: Codable {
    var choiceId: Int32
    var content: ChoiceContentType
}

enum ChoiceContentType: Codable {
    case text(text: String, correct: Bool)
    case image(url: String, correct: Bool)
    
    func isText() -> Bool {
        switch self {
        case .text:
            return true
        default:
            return false
        }
    }
    
    func isCorrect() -> Bool {
        switch self {
        case .text(_, let correct):
            return correct
        case .image(_, let correct):
            return correct
        }
    }
}

enum QuestionChoice: Codable {
    case single(options: [ChoiceContent])
    case multi(options: [ChoiceContent])
    case yesNo(truth: Bool)
    case text(content: String)
    
    func getSingleChoices() -> [ChoiceContent]? {
        switch self {
        case .single(let options):
            return options
        default:
            return nil
        }
    }
    
    func getMultiChoices() -> [ChoiceContent]? {
        switch self {
        case .multi(let options):
            return options
        default:
            return nil
        }
    }
    
    func getTextChoice() -> String? {
        switch self {
        case .text(let content):
            return content
        default:
            return nil
        }
    }
    
    func showOptions() -> Bool {
        switch self {
        case .text:
            return false
        default:
            return true
        }
    }
}

enum FontSize: String, Codable {
    case xs = "xs"
    case sm = "sm"
    case md = "md"
    case lg = "lg"
    case xl = "xl"
    
    func getFontSize() -> Int {
        switch self {
        case .xs:
            return 14
        case .sm:
            return 16
        case .md:
            return 20
        case .lg:
            return 28
        case .xl:
            return 80
        }
    }
}

struct FlipCardCollection: Codable, Hashable {
    static func == (lhs: FlipCardCollection, rhs: FlipCardCollection) -> Bool {
        return lhs.id == rhs.id
    }
    
    var name: String
    var id: UUID
    var description: String
    var cardColorName: FlipCardColor
    var isBuiltIn: Bool?
    var isFlashCard: Bool
    
    var hashValue: Int { self.id.hashValue }
    func hash(into hasher: inout Hasher) {
        self.id.hash(into: &hasher)
    }
    func getCardColor() -> Color {
        switch self.cardColorName {
        case .predefined(let name):
            return Color(name)
        case .custom(let red, let blue, let green):
            return Color(uiColor: UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0))
        }
    }
    
}

struct FlipCardCollectionContent: Codable, Hashable {
    var collectionId: UUID
    var questions: [FlipCardQuestion]
    static func == (lhs: FlipCardCollectionContent, rhs: FlipCardCollectionContent) -> Bool {
        return lhs.collectionId == rhs.collectionId
    }
    var hashValue: Int { self.collectionId.hashValue }
    func hash(into hasher: inout Hasher) {
        self.collectionId.hash(into: &hasher)
    }
    static func shuffle(shuffle: Bool, content: FlipCardCollectionContent) -> [FlipCardQuestion] {
        guard shuffle else {
            return content.questions
        }
                
        var shuffledQuestions: [FlipCardQuestion] = []
        let count = content.questions.count
        var indexes = Array(0...(count - 1))
        for _ in 0...count - 1 {
            let i = Int.random(in: 0...count - 1)
            let j = Int.random(in: 0...count - 1)
            let t = indexes[i]
            indexes[i] = indexes[j]
            indexes[j] = t
        }
        
        for i in 0...count - 1 {
            shuffledQuestions.append(content.questions[indexes[i]])
        }
        return shuffledQuestions
    }
}

struct FlipCardCollectionIndex: Codable {
    var collections: [FlipCardCollection]
}

struct FlipCardQuestion: Codable {
    var id: UInt64
    var text: String
    var fontSize: FontSize
    var choices: QuestionChoice
    var explanation: String?
    var imageUrl: String?
}
