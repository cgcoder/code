//
//  ContentView.swift
//  LearnCombine
//
//  Created by Gopinath chandrasekaran on 8/30/23.
//

import SwiftUI

struct ContentView: View {
    @State var text: String = ""
    
    var body: some View {
        VStack {
            TextField(text: $text) {
                Text("Enter")
            }
            Text(text)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
