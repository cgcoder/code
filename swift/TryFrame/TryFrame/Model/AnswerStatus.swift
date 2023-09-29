//
//  AnswerStatus.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/23/23.
//

import Foundation


struct AnswerStatus {
    var isFrozen: Bool
    var correctness: Correctness
}

enum Correctness {
    case correct
    case partialCorrect
    case skipped
    case wrong
    case unsupported
}
