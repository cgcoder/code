//
//  Movie.swift
//  NavigationAnimation
//
//  Created by Gopinath chandrasekaran on 8/23/23.
//

import Foundation

struct Movie: Identifiable {
    var id: Int
    var name: String
    var description: String
    var genre: String
    var thumbnailUrl: String
    var rating: Int
}

class SampleData {
    static var movieList: [Movie] = [
        Movie(id: 1, name: "Oppenheimer", description: "A movie about creator of nuclear bombs", genre: "Drama",
              thumbnailUrl: "https://upload.wikimedia.org/wikipedia/en/thumb/4/4a/Oppenheimer_%28film%29.jpg/220px-Oppenheimer_%28film%29.jpg", rating: 3),
        Movie(id: 2, name: "Oppenheimer", description: "A movie about creator of nuclear bombs", genre: "Drama",
              thumbnailUrl: "https://upload.wikimedia.org/wikipedia/en/thumb/4/4a/Oppenheimer_%28film%29.jpg/220px-Oppenheimer_%28film%29.jpg", rating: 3),
        Movie(id: 3, name: "Oppenheimer", description: "A movie about creator of nuclear bombs", genre: "Drama",
              thumbnailUrl: "https://upload.wikimedia.org/wikipedia/en/thumb/4/4a/Oppenheimer_%28film%29.jpg/220px-Oppenheimer_%28film%29.jpg", rating: 3),
        Movie(id: 4, name: "Oppenheimer", description: "A movie about creator of nuclear bombs", genre: "Drama",
              thumbnailUrl: "https://upload.wikimedia.org/wikipedia/en/thumb/4/4a/Oppenheimer_%28film%29.jpg/220px-Oppenheimer_%28film%29.jpg", rating: 3),
        Movie(id: 5, name: "Oppenheimer", description: "A movie about creator of nuclear bombs", genre: "Drama",
              thumbnailUrl: "https://upload.wikimedia.org/wikipedia/en/thumb/4/4a/Oppenheimer_%28film%29.jpg/220px-Oppenheimer_%28film%29.jpg", rating: 3)]
}
