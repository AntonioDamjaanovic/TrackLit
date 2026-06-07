//
//  Book.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

struct Book: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let title: String?
    let description: String?
    let contributions: [Contribution]?
    let genres: [String]?
    let releaseYear: Int?
    let image: RemoteImage?
    let pages: Int?
    let contentWarnings: [String]?
    let moods: [String]?
    let rating: Double?
    let ratingsCount: Int?
    let usersRead: Int?
    let userRating: Int?
    let shelf: ShelfState?
    let onPage: Int?
    let finishedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, title, contributions, pages, description, genres, image, rating, moods, userRating, shelf, onPage, finishedAt
        
        case releaseYear = "release_year"
        case contentWarnings = "content_warnings"
        case ratingsCount = "ratings_count"
        case usersRead = "users_read_count"
    }
    
    static var example: Book {
        let author = Author.example
        let image = RemoteImage.bookExample
        let description = "Set on the desert planet Arrakis, Dune is the story of the boy Paul Atreides, heir to a noble family tasked with ruling an inhospitable world where the only thing of value is the “spice” melange, a drug capable of extending life and enhancing consciousness."
        let contributions = [Contribution(author: author, contribution: "")]
        let genres = ["Science Fiction", "Fiction", "Fantasy"]
        let contentWarnings = ["Violence", "Death", "Death of parent", "War"]
        let moods = ["Adventurous", "challenging", "mysterious", "tense", "dark"]
        
        return Book(id: "312460", title: "Dune", description: description, contributions: contributions, genres: genres, releaseYear: 1965, image: image, pages: 704, contentWarnings: contentWarnings, moods: moods, rating: 4.31598440545809, ratingsCount: 5130, usersRead: 6994, userRating: 0, shelf: .notOnShelf, onPage: 127, finishedAt: nil)
    }
    
    static var example2: Book {
        let author = Author.example
        let image = RemoteImage.bookExample
        let description = "Dune Messiah continues the story of Paul Atreides, who has become Emperor of the known universe after leading the Fremen to victory. Now, twelve years later, Paul must face the consequences of his choices as a conspiracy forms against him."
        let contributions = [Contribution(author: author, contribution: "")]
        let genres = ["Science Fiction", "Fiction", "Fantasy"]
        let contentWarnings = ["Violence", "Death", "War", "Political intrigue"]
        let moods = ["Dark", "mysterious", "tense", "philosophical", "melancholic"]
        
        return Book(id: "312461", title: "Dune Messiah", description: description, contributions: contributions, genres: genres, releaseYear: 1969, image: image, pages: 226, contentWarnings: contentWarnings, moods: moods, rating: 3.98, ratingsCount: 3200, usersRead: 4500, userRating: 0, shelf: .notOnShelf, onPage: 0, finishedAt: nil)
    }
}


import Playgrounds

#Playground {
    let url = URL(string: "https://api.hardcover.app/v1/graphql")!
    
    let searchTerm = "The Last Wish"
    let body: [String: Any] = [
        "query": "query SearchBooks { search(query: \"\(searchTerm)\", per_page: 10) { results } }"
    ]

    let bodyData = try JSONSerialization.data(withJSONObject: body)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(Config.hardcoverAPIKey, forHTTPHeaderField: "authorization")
    request.httpBody = bodyData
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
        
        let apiSearchResponse: APISearchResponse = try JSONDecoder().decode(APISearchResponse.self, from: data)
        
        let books = apiSearchResponse.data.search.results.hits.map { $0.document }
        
    } catch {
        print(error)
    }
}
