//
//  Extensions.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/15/23.
//

import Foundation
import SwiftUI

extension View {
    func errorAlert(error: Binding<Error?>, errorMessage: String? = nil, buttonTitle: String = "OK") -> some View {
        
        var text = "Unable to complete this action. Try again!"
        
        if let error = error.wrappedValue {
            text = error.localizedDescription
        }
        
        return alert("Error", isPresented: .constant(error.wrappedValue != nil), actions: {
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        }, message: {
            Text(text)
        })
        
    }
}
