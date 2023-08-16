//
//  ContentView.swift
//  MovieFan
//
//  Created by Chandrasekaran, Gopinath on 8/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var movies: FetchedResults<Movie>
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            List {
                ForEach(movies, id: \.id) {
                    Text($0.name ?? "Unknown")
                }
            }
            
            Button("Add") {
                let m = Movie(context: moc)
                m.name = "Movie 1"
                m.rating = 5
                m.year = 1985
                m.id = UUID()
                
                try? moc.save()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
