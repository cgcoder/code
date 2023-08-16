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
        return alert("Error", isPresented: .constant(error.wrappedValue != nil), actions: {
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        }, message: {
            Text("Unable to complete this action. Try again!")
        })
        
    }
}
