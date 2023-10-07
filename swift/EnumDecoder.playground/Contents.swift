import UIKit
import SwiftUI

struct Student {
    var name: String
    
    mutating func update() -> Void {
        self.name = ""
    }
}

enum FlipCardColor: Codable {
    case predefined(name: String)
    case custom(red: Int, blue: Int, green: Int)
}

enum ChoiceContent: Codable {
    case text(text: String, correct: Bool)
    case image(url: String, correct: Bool)
    case boolean(truth: Bool)
}

enum QuestionChoice: Codable {
    case single(options: [ChoiceContent])
    case multi(options: [ChoiceContent])
    case yesNo(options: [ChoiceContent])
    case text
}

struct FlipCardCollection: Codable {
    var name: String
    var id: UUID
    var description: String
    var cardColorName: FlipCardColor
    var isBuiltIn: Bool?
}

struct FlipCardQuestion: Codable {
    var id: UUID
    var text: String
    var choices: QuestionChoice
}

var data = """
{
   "id": "176b7850-49a8-11ee-be56-0242ac120002",
   "text": "Text of the question",
   "options": {
      "singleChoice": {
            "options": [
              {
                 "textOption": {"text": "answer 1", "correct": false}
              },
              {
                 "textOption": {"text": "answer 2", "correct": false}
              },
              {
                 "textOption": {"text": "answer 3", "correct": true}
              }
          ]
      }
   }
}
"""
do {
    let question = try JSONDecoder().decode(FlipCardQuestion.self, from: data.data(using: .utf8)!)
} catch {
    print("\(error)")
}

