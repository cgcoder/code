//
//  ChildView.swift
//  Test
//
//  Created by Chandrasekaran, Gopinath on 8/15/23.
//

import SwiftUI

struct ChildView: View {
    
    @StateObject var model: Model
    
    var body: some View {
        VStack {
            TextField("Enter description", text: $model.description)
        }
    }
}
