//
//  Author.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

struct Author: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String?
    let image: RemoteImage?
    
    static var example: Author {
        let image = RemoteImage.authorExample
        return Author(id: 11, name: "Frank Herbert", image: image)
    }
}
