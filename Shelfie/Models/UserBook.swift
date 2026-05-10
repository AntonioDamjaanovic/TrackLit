//
//  UserBook.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 08.05.2026..
//

import Foundation

struct UserBook: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let title: String?
    let image: RemoteImage?
    let shelf: String
    let rating: Int
    
    init(book: Book, shelf: ShelfState, rating: Int) {
        self.id = book.id
        self.title = book.title
        self.image = book.image
        self.shelf = shelf.rawValue
        self.rating = rating
    }
}
