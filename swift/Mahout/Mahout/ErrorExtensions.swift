//
//  ErrorExtensions.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/15/23.
//

import Foundation
import SwiftUI

struct AppError: LocalizedError {
    let rootCause: LocalizedError?
    var errorDescStr: String? = nil
    var recoverySuggStr: String? = nil
    
    var errorDescription: String? {
        rootCause?.errorDescription ?? self.errorDescStr ?? "Unknown"
    }
    
    var recoverySuggestion: String? {
        rootCause?.recoverySuggestion ?? self.recoverySuggStr ?? ""
    }
    
    init?(error: Error) {
        guard let err = error as? LocalizedError else { return nil }
        rootCause = err
    }
    
    init(err: String, recovery: String? = nil) {
        self.errorDescStr = err
        self.recoverySuggStr = recovery
        self.rootCause = nil
    }
    
}

extension Error {
    func asAppError() -> AppError? {
        AppError(error: self)
    }
}


