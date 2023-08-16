//
//  ContentView.swift
//  Test
//
//  Created by Chandrasekaran, Gopinath on 8/15/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var model = Model()
    
    var body: some View {
        VStack {
            TextField("Enter name", text: $model.name)
            ChildView(model: model)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
