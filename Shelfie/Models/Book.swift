//
//  Book.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

struct Book: Codable, Identifiable, Equatable, Hashable, BookRepresentable {
    let id: String
    let title: String?
    let description: String?
    let contributions: [Contribution]?
    let genres: [String]?
    let featuredSeries: FeaturedSeries?
    let releaseYear: Int?
    let image: RemoteImage?
    let pages: Int?
    let isbns: [String]
    let contentWarnings: [String]?
    let moods: [String]?
    let rating: Double?
    let ratingsCount: Int?
    let reviewsCount: Int?
    let usersRead: Int?
    let featuredSeriesPosition: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, contributions, pages, description, genres, image, rating, isbns, moods
        
        case releaseYear = "release_year"
        case contentWarnings = "content_warnings"
        case ratingsCount = "ratings_count"
        case reviewsCount = "reviews_count"
        case usersRead = "users_read_count"
        case featuredSeries = "featured_series"
        case featuredSeriesPosition = "featured_series_position"
    }
    
    static var example: Book {
        let author = Author.example
        let image = RemoteImage.bookExample
        let description = "Set on the desert planet Arrakis, Dune is the story of the boy Paul Atreides, heir to a noble family tasked with ruling an inhospitable world where the only thing of value is the “spice” melange, a drug capable of extending life and enhancing consciousness."
        let contributions = [Contribution(author: author, contribution: "")]
        let genres = ["Science Fiction", "Fiction", "Fantasy"]
        let bookSearies = BookSeries(id: 1150, booksCount: 36, name: "Dune", primaryBooksCount: 6)
        let featuredSeries = FeaturedSeries(id: 2448, position: 1, unreleased: false, series: bookSearies)
        let isbns = ["9029002573", "9789029002578", "3641139570", "9783641139575", "9780441014057", "147323395X", "9781473233959", "9786171286085"]
        let contentWarnings = ["Violence", "Death", "Death of parent", "War"]
        let moods = ["Adventurous", "challenging", "mysterious", "tense", "dark"]
        
        return Book(id: "312460", title: "Dune", description: description, contributions: contributions, genres: genres, featuredSeries: featuredSeries, releaseYear: 1965, image: image, pages: 704, isbns: isbns, contentWarnings: contentWarnings, moods: moods, rating: 4.31598440545809, ratingsCount: 5130, reviewsCount: 387, usersRead: 6994, featuredSeriesPosition: 1)
    }
    
    static var example2: Book {
        let author = Author.example
        let image = RemoteImage.bookExample
        let description = "Dune Messiah continues the story of Paul Atreides, who has become Emperor of the known universe after leading the Fremen to victory. Now, twelve years later, Paul must face the consequences of his choices as a conspiracy forms against him."
        let contributions = [Contribution(author: author, contribution: "")]
        let genres = ["Science Fiction", "Fiction", "Fantasy"]
        let bookSeries = BookSeries(id: 1150, booksCount: 36, name: "Dune", primaryBooksCount: 6)
        let featuredSeries = FeaturedSeries(id: 2449, position: 2, unreleased: false, series: bookSeries)
        let isbns = ["9780441015221", "0441015220", "9780575073777", "0575073772"]
        let contentWarnings = ["Violence", "Death", "War", "Political intrigue"]
        let moods = ["Dark", "mysterious", "tense", "philosophical", "melancholic"]
        
        return Book(id: "312461", title: "Dune Messiah", description: description, contributions: contributions, genres: genres, featuredSeries: featuredSeries, releaseYear: 1969, image: image, pages: 226, isbns: isbns, contentWarnings: contentWarnings, moods: moods, rating: 3.98, ratingsCount: 3200, reviewsCount: 241, usersRead: 4500, featuredSeriesPosition: 2)
    }
}

import Playgrounds

#Playground {
    let url = URL(string: "https://api.hardcover.app/v1/graphql")!
    
    let searchTerm = "Dune"
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
        
        //if let jsonString = String(data: data, encoding: .utf8) {
        //    print(jsonString)
        //}
        
        let apiSearchResponse: APISearchResponse = try JSONDecoder().decode(APISearchResponse.self, from: data)
        
        let books = apiSearchResponse.data.search.results.hits.map { $0.document }
        
    } catch {
        print(error)
    }
}
