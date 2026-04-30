//
//  Author.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

struct Author: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    //let bio: String
    //let bornDate: String
    //let deathDate: String
    //let gender: Int
    let image: Image?
    
    //enum CodingKeys: String, CodingKey {
    //    case id, name, bio
    //
    //    case bornDate = "born_date"
    //    case deathDate = "death_date"
    //    case gender = "gender_id"
    //    case image = "url"
    //}
    
    static var example: Author {
        let image = Image.authorExample
        return Author(id: 11, name: "Frank Herbert", image: image)
    }
}
