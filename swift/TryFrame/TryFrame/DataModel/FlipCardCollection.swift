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
    case boolean(truth: Bool)
    
    func isText() -> Bool {
        switch self {
        case .text:
            return true
        default:
            return false
        }
    }
}

enum QuestionChoice: Codable {
    case single(options: [ChoiceContent])
    case multi(options: [ChoiceContent])
    case yesNo(options: [ChoiceContent])
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

struct FlipCardCollection: Codable {
    var name: String
    var id: UUID
    var description: String
    var cardColorName: FlipCardColor
    var isBuiltIn: Bool?
    
    func getCardColor() -> UIColor {
        switch self.cardColorName {
        case .predefined(let name):
            return UIColor(named: name) ?? UIColor.gray
        case .custom(let red, let blue, let green):
            return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0) 
        }
    }
}

struct FlipCardCollectionContent: Codable {
    var collectionId: UUID
    var questions: [FlipCardQuestion]
    
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
}
