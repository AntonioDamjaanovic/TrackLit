//
//  Image.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

struct Image: Codable, Identifiable, Equatable {
    let id: Int?
    let url: String?
    
    static var bookExample: Image {
        return Image(id: 1385811, url: "https://assets.hardcover.app/editions/30426415/8362709973192601-9780441013593-us.jpg")
    }
    
    static var authorExample: Image {
        return Image(id: 6820511, url: "https://assets.hardcover.app/author/171873/ff282134-df3b-4a08-ac98-14ebb915dd91.jpg")
    }
}
