//
//  BookSeries.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 24.04.2026..
//

import Foundation

struct BookSeries: Codable, Identifiable, Equatable {
    let id: Int
    let booksCount: Int
    let name: String
    let primaryBooksCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        
        case booksCount = "books_count"
        case primaryBooksCount = "primary_books_count"
    }
}
