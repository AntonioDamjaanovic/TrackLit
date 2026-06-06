//
//  GenreCount.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 06.06.2026..
//

import Foundation

struct GenreCount: Identifiable, Equatable {
    let genre: String
    let count: Int
    var id: String { genre }
}
