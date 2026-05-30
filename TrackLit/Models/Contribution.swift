//
//  Contribution.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 24.04.2026..
//

import Foundation

struct Contribution: Codable, Equatable, Hashable {
    let author: Author
    let contribution: String?
}
