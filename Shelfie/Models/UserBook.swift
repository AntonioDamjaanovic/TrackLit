//
//  UserBook.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 08.05.2026..
//

import Foundation

struct UserBook: Codable, Identifiable, Equatable, Hashable, BookRepresentable {
    let id: String
    let title: String?
    let image: RemoteImage?
    let shelf: ShelfState
    let contributions: [Contribution]?
    let rating: Double?
    
    init(book: Book, shelf: ShelfState, rating: Double) {
        self.id = book.id
        self.title = book.title
        self.image = book.image
        self.shelf = shelf
        self.rating = rating
        self.contributions = book.contributions
    }
}
