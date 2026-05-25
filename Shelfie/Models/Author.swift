//
//  Author.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

struct Author: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String?
    //let bio: String
    //let bornDate: String
    //let deathDate: String
    //let gender: Int
    let image: RemoteImage?
    
    //enum CodingKeys: String, CodingKey {
    //    case id, name, bio
    //
    //    case bornDate = "born_date"
    //    case deathDate = "death_date"
    //    case gender = "gender_id"
    //    case image = "url"
    //}
    
    static var example: Author {
        let image = RemoteImage.authorExample
        return Author(id: 11, name: "Frank Herbert", image: image)
    }
}
