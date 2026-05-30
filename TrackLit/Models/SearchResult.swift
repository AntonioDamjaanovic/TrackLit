//
//  SearchResult.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 24.04.2026..
//

import Foundation

struct SearchResult: Codable {
    let hits: [Hit]
    let found: Int
}
