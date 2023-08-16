//
//  ErrorExtensions.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/15/23.
//

import Foundation
import SwiftUI

struct AppError: LocalizedError {
    let rootCause: LocalizedError
    var errorDescription: String? {
        rootCause.errorDescription
    }
    var recoverySuggestion: String? {
        rootCause.recoverySuggestion
    }
    
    init?(error: Error) {
        guard let err = error as? LocalizedError else { return nil }
        rootCause = err
    }
}

extension Error {
    func asAppError() -> AppError? {
        AppError(error: self)
    }
}


