//
//  ContentView.swift
//  NavigationAnimation
//
//  Created by Gopinath chandrasekaran on 8/23/23.
//

import SwiftUI
import NavigationTransitions

extension AnyNavigationTransition {
    static var swing: Self {
        .init(Swing())
    }
}

struct Swing: NavigationTransition {
    var body: some NavigationTransition {
        MirrorPush {
            let angle = 20.0
            let offset = 0.0
            OnInsertion {
                ZPosition(1)
                //Rotate(.degrees(-angle))
                // Offset(x: offset)
                Opacity()
                Scale(0)
            }
            OnRemoval {
                
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(SampleData.movieList, id: \.self.id) {
                MovieRowView(movie: $0)
            }
        }
        .navigationTransition(.swing)
    }
}

struct UrlImage: View {
    var url: String
    var fullsize: Bool = false
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                if (!fullsize) {
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 60, maxHeight: 100)
                }
                else {
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                }
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                // Since the AsyncImagePhase enum isn't frozen,
                // we need to add this currently unused fallback
                // to handle any new cases that might be added
                // in the future:
                EmptyView()
            }
        }
    }
}

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            HStack(spacing: 10) {
                UrlImage(url: movie.thumbnailUrl)
                VStack(alignment: .leading) {
                    Text(movie.name)
                    Text(movie.description).foregroundColor(Color.secondary)
                    Text("Rating: \(movie.rating)")
                    Spacer()
                }
                .padding(.top, 10)
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
