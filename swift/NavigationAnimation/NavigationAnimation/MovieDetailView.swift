//
//  MovieDetailView.swift
//  NavigationAnimation
//
//  Created by Gopinath chandrasekaran on 8/23/23.
//

import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    var body: some View {
        ZStack {
            Color.black
            VStack {
                UrlImage(url: movie.thumbnailUrl, fullsize: true)
                Spacer()
            }
            HStack() {
                Spacer()
                Button(action: {
                              print("Circular Button tapped")
                            }) {
                                Image(systemName: "xmark.circle").scaleEffect(2)
                            }
                            .padding(5)
                            .foregroundColor(.white)
                            .clipShape(Circle())
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 50)
            .padding(.trailing, 10)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: SampleData.movieList[0])
    }
}
